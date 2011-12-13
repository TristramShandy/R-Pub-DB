# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
a0 = Author.create({:first_name => "Michael", :last_name => "Ulm", :affiliation => "AIT"})
a1 = Author.create({:first_name => "Dietmar", :last_name => "Bauer", :affiliation => "AIT"})
a2 = Author.create({:first_name => "Norbert", :last_name => "Brändle", :affiliation => "AIT"})
u0 = User.create({:name => "MUlm", :rolemask => 0, :author_id => a0.id})
u1 = User.create({:name => "DBauer", :rolemask => 0, :author_id => a1.id})
u2 = User.create({:name => "NBraendle", :rolemask => 4, :author_id => a2.id})
j0 = Journal.create({:name => "Science", :publisher => "American Association for the Advancement of Science", :issn => "0036-8075", :url => "http://www.sciencemag.org/"})
j0 = Journal.create({:name => "Nature", :publisher => "Nature Publishing Group", :issn => "0028-0836", :url => "http://www.nature.com/nature/index.html"})
c0 = Conference.create({:name => "NIPS 2012", :begin_date => "2012-12-03", :end_date => "2012-12-06", :deadline => "2012-06-02", :acceptance => "2012-09-03", :due => "2012-09-03", :url => "http://nips.cc/Conferences/2012", :location => "Lake Tahoe, Nevada, USA"})
