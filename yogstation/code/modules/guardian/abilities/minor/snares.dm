/datum/guardian_ability/minor/snare
	name = "Surveillance Snares"
	desc = "The guardian can lay a surveillance snare, which alerts the guardian and the user to anyone who crosses it."
	cost = 1

/datum/guardian_ability/minor/snare/Apply()
	add_verb(guardian, list(/mob/living/simple_animal/hostile/guardian/proc/Snare, /mob/living/simple_animal/hostile/guardian/proc/DisarmSnare))

/datum/guardian_ability/minor/snare/Remove()
	remove_verb(guardian, list(/mob/living/simple_animal/hostile/guardian/proc/Snare, /mob/living/simple_animal/hostile/guardian/proc/DisarmSnare))

/mob/living/simple_animal/hostile/guardian/proc/Snare()
	set name = "Set Surveillance Snare"
	set category = "Guardian"
	set desc = "Set an invisible snare that will alert you when living creatures walk over it. Max of 5"
	if(snares.len <6)
		var/turf/snare_loc = get_turf(src.loc)
		var/obj/effect/snare/S = new /obj/effect/snare(snare_loc)
		S.spawner = src
		S.name = "[get_area(snare_loc)] snare ([rand(1, 1000)])"
		snares |= S
		to_chat(src, span_bolddanger("Surveillance snare deployed!"))
	else
		to_chat(src, span_bolddanger("You have too many snares deployed. Remove some first."))

/mob/living/simple_animal/hostile/guardian/proc/DisarmSnare()
	set name = "Remove Surveillance Snare"
	set category = "Guardian"
	set desc = "Disarm unwanted surveillance snares."
	var/picked_snare = input(src, "Pick which snare to remove", "Remove Snare") as null|anything in src.snares
	if(picked_snare)
		snares -= picked_snare
		qdel(picked_snare)
		to_chat(src, span_bolddanger("Snare disarmed."))

// the snare

/obj/effect/snare
	name = "snare"
	desc = "You shouldn't be seeing this!"
	var/mob/living/simple_animal/hostile/guardian/spawner
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/snare/Crossed(AM as mob|obj)
	. = ..()
	if(isliving(AM) && spawner && spawner?.summoner?.current && AM != spawner && !spawner.hasmatchingsummoner(AM))
		to_chat(spawner.summoner.current, span_bolddanger("[AM] has crossed surveillance snare, [name]."))
		var/list/guardians = spawner.summoner.current.hasparasites()
		for(var/para in guardians)
			to_chat(para, span_bolddanger("[AM] has crossed surveillance snare, [name]."))

/obj/effect/snare/singularity_act()
	return

/obj/effect/snare/singularity_pull()
	return
