# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

budget_periods = [
  { name: "Daily",       abbreviation: "Dly",     multiplier: 1,          sort_order: 1 },
  { name: "Weekly",      abbreviation: "Wkly",    multiplier: (365.0/52), sort_order: 2 },
  { name: "Fortnightly", abbreviation: "Fortn",   multiplier: (365.0/26), sort_order: 3 },
  { name: "Monthly",     abbreviation: "Mthly",   multiplier: (365.0/12), sort_order: 4 },
  { name: "3 Monthly",   abbreviation: "3 Mthly", multiplier: (365.0/4),  sort_order: 5 },
  { name: "4 Monthly",   abbreviation: "4 Mthly", multiplier: (365.0/3),  sort_order: 6 },
  { name: "6 Monthly",   abbreviation: "6 Mthly", multiplier: (365.0/2),  sort_order: 7 },
  { name: "Yearly",      abbreviation: "Yrly",    multiplier: 365,        sort_order: 8 }
]

budget_periods.each do |attrs|
  Budgets::Period.where(name: attrs[:name]).first_or_create!(attrs)
end