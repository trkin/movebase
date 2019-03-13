# Move Index

This project aims to make it easier for people search for a group which they can
join and move their body together. It index all activities like hiking, running,
kayaking, and can perform filtering to specific disciplines like split boarding.

# Model

User starts by defining what basic activity it wants (like kayaking or
swimming). Multi-activity (triathlon) is activity that BELONGS_TO multiple basic
activities in activity_associations table.
Discipline (K2 number_of_crew=2) belongs to activity and has it's specific
discipline_requirements (K2 boat) but also discipline_happening conditions (age
interval, distance, max time).
Properties which are not required (like fresh water, terain road, cros_country)
or hard to measure (like walking speed)
are defined in discipline_happening_tags.
* skyrunning vertical 1KM TERAIN=cross_country
* stairs run TERAIN=stairs
* cross duathlon 2-6y is modeled with AGE_MIN, AGE_MAX, LENGTH(total 2km),
  EQUIPMENT=any_bicycle, DOCUMENTS=medical_report, TERRAIN=cross_country
* K4-500m Senior AGE_MIN=16, LENGTH=500m, EQUIPMENT=sprint_kayak,
  DOCUMENTS=club_registration_or_medical_report, multi person is defined with
  NUMBER_OF_CREW=4
* Ibar downriver LENGTH=50km, EQUIPMENT=any_boat_without_motor,
  TERRAIN=slow_water
* sprint kayak marathon EQUIPMENT=sprint_kayak
* recreational kayak marathon EQUIPMENT=any_kayak
* sprint triatlon TERAIN=river_road_road
* sprint triatlon TERAIN=swimming_pool_road_road
* quadrathlon_swimming_kayak_bicycle_running EQUIPMENT=kayak_bicycle
* relay_running (2x12km) is modeled with number of crew (it is one person at one
  time) and association.

Some happenings are repeating (every day, week, month, year).
Non olimpic disciplines like dog walking, waste removal(street cleaning),
pokemon hunting, yoga, lunch hiking, kayaking with a dog.

Happening can be organized without club (gathering).
Similar
https://www.britishcanoeing.org.uk/competition/whatson/eventcalendars
http://canoeracing.org.uk/marathon/index.php/category/international-racing/intl_masters/
https://gopaddlingweek.info/go-paddling-week-event-finder/
https://gopaddling.info/category/explore/

TODO

finish search happening test

# What is your move index ?

# Installation

This project uses:

* Ruby on Rails
* Postresql

# Tests

Run tests with `rake`

# Slides

Navigate to `/slides`








Mnoge stvari se odvijaju oko nas a da mi o tome nismo obavesteni. Na primer u 4.
maja u Novom Sadu su se odigrala dva dogadjaja.
Prvi je planinarski maraton na fruskoj gori


i kajakaska regata na sodrosu.


Nasa inovacija je sajt za prikaz svih sportskih dogadjaja, na kojima se moze
ucestvovati samostalno ili preko kluba.
Svaka disciplina ima odredjene uslove kao sto je neophodna oprema, vremenski
limit, duzina staze i uzrast ucesnika.

Nas sajt omogucava korisnicima da na laksi nacin pronadju dogadjaje koji njima
odgovaraju

Takodje se zainteresovani mogu dogovarati oko zajednickog prevoza.

Na nasem sajtu mogu da se postave linkovi ka svim stranicama koje se objave
nakon desavanja (rezultati, fotografije i video snimci)


, a da ne moraju da listaju po fejsbuku i da prate odredjenu stranicu
da bi nasli informacije o dogadjaju
Pored pronalazenja dogadjaja, nas sajt omogucava da se povezu rezultati i
objave nakon dogadjaja. Na primer, posle tradicionalnog godisnjeg maratona u
Sidu, pojedinci i planinarske organizacije sirom Srbije mogu da naprave
izvestaje na svojim sajtovima, da okace fotografije na svojim FB profilima,
objave snimke na Youtube... 



Da li ste znali da je na strandu u nedelju u 12h Triatlon i da na njemu mogu
ucestvovati deca od 6 godina ?






