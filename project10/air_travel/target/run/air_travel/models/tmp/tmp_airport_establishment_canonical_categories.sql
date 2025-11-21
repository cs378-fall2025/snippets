
  
    

    create or replace table `cs378-fa2025`.`dbt_air_travel_tmp`.`tmp_airport_establishment_canonical_categories`
      
    
    

    
    OPTIONS()
    as (
      with tmp_airport_establishment_canonical_categories as (
    select 'Quick Service & Grab-and-Go' as broad_category, 'National/International Fast Food Chains' as sub_category
	union all
    select 'Quick Service & Grab-and-Go' as broad_category, 'Coffee & Beverage Shops' as sub_category
	union all
    select 'Quick Service & Grab-and-Go' as broad_category, 'Snack Kiosks' as sub_category
	union all
    select 'Quick Service & Grab-and-Go' as broad_category, 'Pre-Packaged Foods' as sub_category
	union all
    select 'Fast Casual' as broad_category, 'Gourmet Burgers & Sandwiches' as sub_category
	union all
    select 'Fast Casual' as broad_category, 'Build-Your-Own Concepts' as sub_category
	union all
    select 'Fast Casual' as broad_category, 'Pizzerias' as sub_category
	union all
    select 'Full-Service Dining' as broad_category, 'Casual Dining Restaurants' as sub_category
	union all
    select 'Full-Service Dining' as broad_category, 'Upscale & Chef-Driven Restaurants' as sub_category
	union all
    select 'Full-Service Dining' as broad_category, 'Themed Restaurants & Sports Bars' as sub_category
	union all
    select 'Bars & Lounges' as broad_category, 'Wine Bars' as sub_category
	union all
    select 'Bars & Lounges' as broad_category, 'Craft Beer Pubs' as sub_category
	union all
    select 'Bars & Lounges' as broad_category, 'Cocktail Lounges' as sub_category
	union all
    select 'Travel Essentials & Convenience' as broad_category, 'Newsstands & Bookstores' as sub_category
	union all
    select 'Travel Essentials & Convenience' as broad_category, 'Pharmacies & Personal Care' as sub_category
	union all
    select 'Travel Essentials & Convenience' as broad_category, 'Travel Gear & Luggage' as sub_category
	union all
    select 'Specialty Retail' as broad_category, 'Electronics' as sub_category
	union all
    select 'Specialty Retail' as broad_category, 'Local Souvenirs & Gifts' as sub_category
	union all
    select 'Specialty Retail' as broad_category, 'Apparel & Accessories' as sub_category
	union all
    select 'Luxury & High-End Goods' as broad_category, 'Confectionery & Gourmet Foods' as sub_category
	union all
    select 'Luxury & High-End Goods' as broad_category, 'Designer Fashion' as sub_category
	union all
    select 'Luxury & High-End Goods' as broad_category, 'Jewelry & Watches' as sub_category
	union all
    select 'Luxury & High-End Goods' as broad_category, 'High-End Cosmetics' as sub_category
	union all
    select 'Duty-Free' as broad_category, 'Liquor & Tobacco' as sub_category
	union all
    select 'Duty-Free' as broad_category, 'Fragrances & Cosmetics' as sub_category
	union all
    select 'Duty-Free' as broad_category, 'Luxury Accessories & Confectionery' as sub_category
	union all
    select 'Passenger Comfort & Wellness' as broad_category, 'Spas & Salons' as sub_category
	union all
    select 'Passenger Comfort & Wellness' as broad_category, 'Pay-Per-Use Lounges' as sub_category
	union all
    select 'Passenger Comfort & Wellness' as broad_category, 'Yoga & Meditation Rooms' as sub_category
	union all
    select 'Passenger Comfort & Wellness' as broad_category, 'Shower Facilities' as sub_category
	union all
    select 'Financial & Business Services' as broad_category, 'Currency Exchan' as sub_category
	union all
    select 'Financial & Business Services' as broad_category, 'ATMs & Banking Services' as sub_category
	union all
    select 'Financial & Business Services' as broad_category, 'Business Centers & Work Pods' as sub_category
	union all
    select 'Practical & Convenience Services' as broad_category, 'Luggage Storage & Wrapping' as sub_category
	union all
    select 'Practical & Convenience Services' as broad_category, 'Postal & Shipping Services' as sub_category
	union all
    select 'Practical & Convenience Services' as broad_category, 'Pet Relief & Care Areas' as sub_category
	union all
    select 'Practical & Convenience Services' as broad_category, 'Vending Machines (non-F&B)' as sub_category
)

select * 
from tmp_airport_establishment_canonical_categories
    );
  