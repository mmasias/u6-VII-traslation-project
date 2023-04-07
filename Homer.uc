
void Homer object# (0x4de) ()
{

	var party = UI_get_party_list();
	var player_name = getAvatarName();
	var polite_title = getPoliteTitle();
	var hour = UI_game_hour();
	var partynum = UI_get_array_size(party);
	var bark;
	var player_is_female = UI_is_pc_female();
	var greeting; //When addressing party as plural or singular
	var avatar_bark;
	var npc_bark;
	var time_of_day = timeFunction(hour);
	var schedule = UI_get_schedule_type(item); //use for schedule specific convos
	var current_schedule = schedule; 
	var gender;
	
	var av_1st_greet;
	var npc_1st_greet;
				
	var av_2nd_greet;
	var npc_2nd_greet;	
	
	var avatar_goodbye;
	var npc_goodbye;
				
	
	//Flags used for conversation flags 
	// use PETRA, SI_ZOMBIE, FREEZE, NAKED, POLYMORPH
	var example = UI_get_item_flag(item, SI_ZOMBIE);
	
	
	//READ flag used to initiate conversations via TALK
	var started_talking = UI_get_item_flag(item, READ);

	if (player_is_female) //
	{
		gender = "sister";
	//	title = "madame";
	}
	else 
	{
		gender = "brother";
	//	title = " ";
	}
	
	//determine single/plural greeting - change as needed
	if (partynum > 1)
		greeting = "friends"; 
	else 
		greeting = "friend"; //Avatar is solo
	
	
	if (event == DOUBLECLICK)
	{
		//Avatar and NPC greeting barks
		av_1st_greet = "@Might we speak?@";
		npc_1st_greet = "@..if we must.@";
				
		av_2nd_greet  = "@Might we speak again?@";
		npc_2nd_greet = "@What now?@";	
		
		//call convo script
		startConvo(item, av_1st_greet, npc_1st_greet, av_2nd_greet, npc_2nd_greet); 
	}
	
	if (started_talking)
	{
		//reset schedule for after convo
		UI_run_schedule(item);
		
		if (gflags[GAVE_HOMER_STORMCLOAK])
		{
			item.say("@You served your purpose by bringing me the cloak... Now I have no further need of you. I have big plans now, and no time to waste talking.@");  
			sayGoodbye2("@Begone!@");
			return;
		}		
		
		if (gflags[FIND_STORMCLOAK]) //on the quest to find the storm cloak
		{
			item.say("@Have you found the storm cloak yet?@");
			if (askYesNo())
			{
				item.say("@Then hand it over and we're even.@ His eyes gleam with greedy anticipation. Do you give him the cloak?@");
				if (askYesNo())
				{
					if (UI_count_objects(PARTY, SHAPE_STORM_CLOAK, 1, 0) > 0)
					{
						item.say("He takes the cloak from you. @Thanks for keeping your word. There's not many that does, these days...@");
						giveExperience(100);
						addKarma(10);
						UI_remove_party_items(1, SHAPE_CLOAK, 1, FRAME_ANY);
						gflags[GAVE_HOMER_STORMCLOAK] = true;
						sayGoodbye2("It's all mine!");
						return;
					}
					else say("You have no storm cloak to give him.");
					sayGoodbye2("Lying dog!");
					return;
				}
				else
				{
					item.say("@Blast ye! If I still had two good legs, I'd keelhaul the lot of you!@*");
					item.say("@We had a deal! Besides, I helped steal that treasure myself, fair and square.@*");
					sayGoodbye2("Can't trust anybody these days..");
					subtractKarma(10);
					return;
				}  
			}
			else 
			{
				item.say("@Then get off your duff and go dig it up!@");
				sayGoodbye2("@Stop wasting time!@");
				return;
			}

		}
		
		//Determine if you've found all 8 pieces of the map yet:
		if (gflags[TALKEDTOHOMERABOUTMAP])
		{
			item.say("@So, have ye found the eight pieces of the map yet?@");
			if (askYesNo())
			{
				if ((UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP1) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP2) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP3) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP4) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP5) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP6) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP7) > 0) && (UI_count_objects(PARTY, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP8) > 0))
				{
					item.say("@Very well. I've been thinking about how we could work out a deal.@*");
					item.say("@I know you want the silver tablet. Far as I'm concerned, you can have it.@*");
					item.say("@All I really want is the magical cloak that's buried with the rest of the treasure. So...@*");
					item.say("@I'll tell you where the ninth piece of the map is if you promise to bring me the cloak.@*");
					item.say("@The rest of the treasure should be loot enough to satisfy you. Is it a deal?@*");
					if (askYesNo())
					{
						item.say("@Okay. The ninth piece of the map is hidden...Right here in my pocket!@ He grins wickedly. I had to keep it safe while you were off gathering the others, didn't I?@");
						item.say("He hands you the last piece of the map. The island in the upper left hand corner is Buccaneer's Den.@");
						UI_add_party_items(1, SHAPE_TREASURE_MAP, QUALITY_ANY, FRAME_MAP9);
						item.say("@You'll keep your word and come right back here with the magic storm cloak, won't you?@");
						if (askYesNo())
						{
							item.say("@Good. Then I'll tell you this: When you reach the island marked with the X, find the three stones and stand in the center.@*");
							item.say("@Then walk three paces due south, nine paces due west, and twelve more paces south. That should put you right next to an old dead tree.@*");
							item.say("@Dig in the patch of dirt just to the south of you, and you'll find the treasure!@*");
							sayGoodbye2("@Now go get it!@");
							
							//sends you on a quest to find stormcloak						
							if (!gflags[FIND_STORMCLOAK])
								gflags[FIND_STORMCLOAK] = true;
							return;
						}	
						else 
						{
							item.say("@Don't want to keep your word now that you have the map, eh? Well, then, I won't tell you where you need to dig to find the treasure!@");
							sayGoodbye2("@Blast ye!@");
							return;
						}
					}
					else 
					{
						item.say("@Suit yourself, mate, that's the only deal I'll offer.@");
						sayGoodbye2("@...fool.@");
						return;
					}

				}
				else 
					item.say("@Best count again. You need eight pieces before I'll bargain with you.@");
			}
			else 
				item.say("@Then what are you wasting my time for?@");
		}
		
		
		if (!UI_get_item_flag(item, MET))
		{
			item.say("A shifty-eyed character. He carries a cane and walks with a slight limp.*");
			UI_set_item_flag(item, MET);
		}
		item.say("He takes your measure, looking you over from head to toe. @What do you want?@");
		
		//standard conversation options
		var options = ["name", "job", "bye"];
		
		if (gflags[LEARNED_ABOUT_TABLET])
			add("silver tablet");

		/* Conversation options based on MET flag of other npc's - delete all if not used
			if (UI_get_item_flag(NPCNAME, MET))
				add ("NPC name");
		*/


		/////////////////////////////////////////////////////////////////////
		// Main conversation thread
		/////////////////////////////////////////////////////////////////////
			converse(options)
			{
				case "name" (remove):
					say("@Who wants to know?@"); 
					var avatar_or_name = chooseFromMenu(["I am the Avatar", ("I am " + player_name)]);
					if (avatar_or_name == "I am the Avatar")
						say("@Fine, 'Avatar', if that's who you really are... You can call me Homer.@");
					else if (avatar_or_name == ("I am " + player_name))
						say("@Fine, '" + player_name + "' - if that's what your name really is... You can call me Homer.@");
					add(["Homer"]);

				case "job" (remove):
					say("@I once sailed on the ship called 'Empire, under Captain Hawkins.@");
					add(["Empire", "Captain Hawkins"]); 

				case "Homer"(remove):
					say("@Well, get on with it!@");  

				case "Empire"(remove):
					say("@It was wrecked on the cape, southwest of here. Not too far from Serpent's Hold.@");

				case "Captain Hawkins"(remove):
					say("His eyes light up with hatred. @That heartless bastard...He was killed by his own men, and it was no worse than he deserved.@*");
					say("He hesitates, then adds quickly, @Of course, I had nothing to do with it.@");

				case "silver tablet"(remove):
					if (UI_count_objects(PARTY, SHAPE_GUILD_BELT, QUALITY_ANY, FRAME_ANY) > 0)
					{
						say("@You're looking for the silver tablet? It's part of Captain Hawkins' buried treasure.@");  // if in guild
						add(["treasure"]);
					}
					else 
					{
						say("He regards you warily. @Who sent you? I see.@ He screws his face up into an even more suspicious expression than before. @Just why do you want to know about it, anyway?@");  // question
						var question = chooseFromMenu(["None of thy business", "I need it"]);
						if (question == "None of thy business")
							say("@Uh-huh. You're not a member of the guild. I don't have to tell you anything.@");
						else if (question == "I need it")
							say("@Uh-huh. You're not a member of the guild. I don't have to tell you anything.@");
						add(["guild"]);
					}

				case "treasure"(remove):
					if (UI_count_objects(PARTY, SHAPE_GUILD_BELT, QUALITY_ANY, FRAME_ANY) > 0)
					{
						say("@It was buried in a small cave.@");  
						add(["cave"]);
					}
					else 
						say("@Don't know anything about it.@");
				

				case "cave"(remove):
					if (UI_count_objects(PARTY, SHAPE_GUILD_BELT, QUALITY_ANY, FRAME_ANY) < 1)
					{
						say("@What are you talking about?@");
					}
					else
					{
						if (!gflags[TALKEDTOHOMERABOUTMAP])
							gflags[TALKEDTOHOMERABOUTMAP] = true;
							
						say("@After Captain Hawkins passed away, we tore his treasure map into nine pieces. The plan was, when nobody was looking for us any more, we'd get together and go dig it up.@*");
						say("@Splitting up the map was my idea - that way nobody could doublecross the others. I figure after all these years the others must have given up, so its alright for me to search for the treasure by myself.@*");
						say("@Trouble is, I've got a bit of the gout in one leg, and I can't travel much any more. Maybe we can help each other out. I know where my piece of the map is hidden, and if you bring me the other eight pieces, perhaps we could make a deal.@*"); 
						say("@I'll tell you all I know about where the pieces might be... Ol' Hawknose set out for the Dry Land, to kill the daemon that is said to live there.@*");
						say("@Sandy, the ship's cook, went to Trinsic with the first mate.@*");
						say("@Old Ybarra said he was headed for the dungeon Shame, looking for more treasure. I think one of the men died in a shipwreck.@*");
						say("@Then there was one more... Can't remember his name, but I've heard tell he settled in Jhelom. He'll be easy to recognize - he has a hook in place o' one of his hands. That's all I know. Perhaps in your travels you can find out where the others have gone.@*");
						say("@When you find the pieces, you can lay them out on the ground to see how they fit together. But remember, only I know where the ninth piece is, so come back here when you've got the other eight.@");  // if in guild say
					}

				case "guild"(remove):
					say("@Go ask Budo. And you didn't hear that from me, understand?@");
					if (!gflags[LEARNED_ABOUT_GUILD])
						gflags[LEARNED_ABOUT_GUILD] = true;

				case "bye"(remove):
					if (UI_count_objects(PARTY, SHAPE_GUILD_BELT, QUALITY_ANY, FRAME_ANY) > 0)
						npc_goodbye = "@Farewell, " + gender + " thief.@"; 
					else 
						npc_goodbye = "@Can't say its been a pleasure.@";
					
					avatar_goodbye = "@Must be going now..@";
					
					//function that is called, do not change this:
					sayGoodbye(item, npc_goodbye, avatar_goodbye);
					break;
		
			}                               
	}
	else scheduleBarks(item);
}