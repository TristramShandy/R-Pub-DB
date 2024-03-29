# sortable.rb
#
# a module that provides methods for sortable items

module Sortable
  # Info on displayed headers.
  # sortable and filterable are supposed to be integers that are defined below
  #   They can take one of three values: C_No, C_Yes, C_Default
  HeaderInfo = Struct.new(:name, :attribute, :sortable, :filterable)

  C_No = 0
  C_Yes = 1
  C_Default = 2

  class HeaderInfo
    MaxStringLength = 20 # default max size of display

    # What to display in the table
    def show(item)
      max_string_length =  MaxStringLength
      str = ""
      case attribute
      when :source
        if item[:journal_id]
          str = "[J] #{item.journal.display_name}"
        elsif item[:conference_id]
          str = "[C] #{item.conference.display_name}"
        elsif item[:book_id]
          str = "[B] #{item.book.display_name}"
        end
      when :reminder_source
        str = item.reminder_source
        max_string_length = 40
      when :authors
        str = item.authors.map {|author| author.display_name}.join(", ")
      when :status
        str = I18n.t(item.status_name)
      when :pdf
        str = (item.pdf.blank? ? I18n.t(:ans_no) : I18n.t(:ans_yes))
      else
        str = item[attribute].to_s
      end

      if str.size > max_string_length
        str = str[0, max_string_length - 3] + "..."
      end

      str
    end

    def is_sortable?
      sortable == C_Yes || sortable == C_Default
    end
  end

  # SortableItem holds information on the item to display
  class Item
    def initialize(item)
      @item = item
    end

  end

  # main class: a collection of items with information on sortability
  class List
    attr_reader :headers, :items, :sort, :direction, :table_name, :default_filter, :err

    def initialize(klass, params, items = nil)
      @table_name = klass.table_name
      @headers = klass.const_get(:DisplayInfo)
      @err = nil

      @direction = (['asc', 'desc'].include?(params[:direction]) ? params[:direction].to_sym : :asc)

      @sort = params[:sort].to_s.to_sym
      found = false
      @filter_headers = []

      # Iterate through headers to check if @sort is an allowable column and find default values
      @headers.each do |a_header|
        @default_sort = a_header if a_header.sortable == C_Default
        @default_filter = a_header if a_header.filterable == C_Default
        found ||= (@sort == a_header.attribute && a_header.is_sortable?)
        @filter_headers << a_header if a_header.filterable == C_Yes || a_header.filterable == C_Default
      end
      @sort = @default_sort.attribute unless found

      if @sort == :scope
        # special treatment for scope necessary, as it is a combination of different attributes
        @items = items ? items : klass.find(:all)
        @items = @items.sort_by {|item| item.scope_string}
      else
        if items
          @items = items.sort_by {|item| item[@sort]}
          @items.reverse! if @direction == :desc
        else
          @items = klass.order("#{@sort} #{@direction}")
        end
      end

      params[:nr_filters].to_i.times do |i|
        unless params["regexp_#{i}"].blank?
          # keep only items that match the regexp
          attr = (params["attr_select_#{i}"].blank? ? @default_filter.attribute : params["attr_select_#{i}"])
          begin
            regexp = Regexp.new(params["regexp_#{i}"], params["ignorecase_#{i}"] == '1')
          
            @items = @items.select {|item| item[attr].to_s =~ regexp}
          rescue RegexpError
            @err = :regexp
          end
        end
      end
    end

    # list of filter attributes usable for options_for_select
    def filter_attributes
      @filter_headers.map {|a_header| [I18n.t(a_header.name), a_header.attribute]}
    end

    def empty?
      @items.empty?
    end
  end
end
