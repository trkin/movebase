# Model

Activity vs Discipline

User starts by defining what basic **activity** it wants (like kayaking or
swimming).

**Discipline** (K2 number_of_crew=2) has_many activities and has
**discipline_requirements** (K2 boat). In case of multi-activity discipline
like triathlon, we have running, swimming and cycling activity. In case of trail
running, discipline has two activities: walking and running.
When we organize **happening** than we also
define **discipline_happening** conditions (gender, age min/max, distance, max
time).
Properties which are optional for that happening (for example: fresh water,
terain road, cros_country) or hard to measure (for example: walking speed) are
defined in
**discipline_happening_tags** which has NAME and value, for example:
|activity|discipline|discipline_happening|discipline_happening_tags|
|running|skyrunning|stara planina vertical 5KM|TERAIN=cross_country
| stairs run TERAIN=stairs
|running,walking|cross duathlon|2-6y AGE_MIN, AGE_MAX, LENGTH(total 2km)|EQUIPMENT=any_bicycle, DOCUMENTS=medical_report, TERRAIN=cross_country
|kayaking|K4 spring kayaking|K4-500m Senior AGE_MIN=16, LENGTH=500m, EQUIPMENT=sprint_kayak,
  DOCUMENTS=club_registration_or_medical_report, multi person is defined with
  NUMBER_OF_CREW=4
* Ibar downriver LENGTH=50km, EQUIPMENT=any_boat_without_motor,
  TERRAIN=slow_water
|kayaking|sprint kayak marathon|zlatno veslo EQUIPMENT=sprint_kayak
* recreational kayak marathon EQUIPMENT=any_kayak
* quadrathlon_swimming_kayak_bicycle_running EQUIPMENT=kayak_bicycle
* relay_running (2x12km) is modeled with number of crew (it is one person at one
  time) and association.

Some happenings are repeating (every day, week, month, year).
Non olimpic disciplines like dog walking, waste removal(street cleaning),
pokemon hunting, yoga, lunch hiking, kayaking with a dog.

Each happening have a club which can be personal (personal gathering) which
have a venue, but it could be just a city (for personal and organizational clubs
that do not have an office)

# Similar

https://www.britishcanoeing.org.uk/competition/whatson/eventcalendars
http://canoeracing.org.uk/marathon/index.php/category/international-racing/intl_masters/
https://gopaddlingweek.info/go-paddling-week-event-finder/
https://gopaddling.info/category/explore/
