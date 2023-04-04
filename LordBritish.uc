
void LordBritish object# (0x494) ()
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
	
	var rand;
	
	var av_1st_greet;
	var npc_1st_greet;
				
	var av_2nd_greet;
	var npc_2nd_greet;	
	
	var avatar_goodbye;
	var npc_goodbye;
				
	
	//Flags used for conversation flags 
	// use PETRA, SI_ZOMBIE, FREEZE, NAKED, POLYMORPH
	var asked_about_oz = UI_get_item_flag(item, SI_ZOMBIE);
	
	
	//READ flag used to initiate conversations via TALK
	var started_talking = UI_get_item_flag(item, READ);

	if (player_is_female) //
	{
	//	pronoun = "  ";
	//	title = "madame";
	}
	else 
	{
	//	pronoun = " ";
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
		av_1st_greet = "@My liege..@";
		npc_1st_greet = "@Avatar, thou art here!@";
				
		av_2nd_greet  = "@My liege..@";
		npc_2nd_greet = "@Yes, Avatar?@";	
		
		//call convo script
		startConvo(item, av_1st_greet, npc_1st_greet, av_2nd_greet, npc_2nd_greet); 
	}
	
	if (started_talking)
	{
		//reset schedule for after convo
		UI_run_schedule(item);
		
		if (!UI_get_item_flag(item, MET))
		{
			//clear intro flag
			gflags[INTRO] = false;
			
			item.say("The noble ruler of Britannia.*");
			item.say("@" + player_name + "! 'Tis good to see thee again. Much hath happened since thou last departed our realm.@");
			
			if (UI_count_objects(PARTY, SHAPE_KEY, QUALITY_LBKEY, FRAME_LBKEY) < 1) //Checks if you have the castle key yet.
			{
				item.say("@Take this key. It will unlock the gatehouse by the southern entrance to the castle. Then you can use the lever inside to raise the portcullis, and the crank will lower the drawbridge.@*");
				item.say("@The same key will also let you into the sewers under the castle. Now let me tell thee what hath transpired since thy last visit.@*");
				UI_add_party_items(1, SHAPE_KEY, QUALITY_LBKEY, FRAME_LBKEY, true);
			}
			item.say("@The vast underworld from which thou didst rescue me hath collapsed. Yet still there are forces of evil abroad in the land.@*");
			item.say("@Britannia is under attack by gargoyles such as those thou just fought. They have been coming up through the dungeons.@*");
			item.say("@Thus far they have mainly been attacking the shrines of the eight virtues.@*");
			item.say("@When the Shrine of Compassion didst fall, Sir Geoffrey sent a party to free it. Do thou ask him of this mission. Perhaps thou canst prove of some assistance.@");
			item.say("@Whilst thou art here, I have a room in the castle set aside for thy personal use. 'Tis in the west wing of the castle, just south of mine own chambers. I have had my servants place some equipment there, in case thou shouldst have need of it.@**");
			item.say("@Of course, thou mayst feel free to borrow anything in my castle, if thou shouldst need it.@");
			item.say("@Lastly, any time thou dost need healing, do thou but ask me. If thou doth wish me to repeat all this later thou need but ask.@");
			add(["Geoffrey", "shrines", "virtues", "Shrine of Compassion"]);
			
		}
		else 
		{
			item.say("The noble ruler of Britannia.*");
			item.say("@Good " + time_of_day + ", " + player_name + ". What wouldst thou speak of?@");
		
		}
			
		
		//standard conversation options
		var options = ["name", "job", "bye", "repeat", "heal"];
		
		//when Nystul asks about Orb
		if (gflags[ASKED_NYSTUL_ABOUT_ORB])
			add("orb");
			
		if (isNearby(SHERRY) || UI_get_item_flag(SHERRY, MET))
			add("Sherry");	
			
		if (gflags[MR_NOSE])
			add("Mr. Nose");	
		
		//killed Chuckles in front of Drudgeworth, cremated him
		if (gflags[CHUCKLES_CREMATED])
			add("Chuckles");
		
		//can tattle on Chuckles	
		if (gflags[CHUCKLES_SECRET] && !gflags[TATTLED_ON_CHUCKLES])
			add("tell Chuckles' secret");
			


	/////////////////////////////////////////////////////////////////////
	// Main conversation thread
	/////////////////////////////////////////////////////////////////////
		converse(options)
		{
			case "name"(remove):
				say("@I am Lord British, as thou knowest well.@");
				
			case "job"(remove):
				say("@Thanks to thee, I sit once more upon the throne of Britannia.@*");
				say("@Though 'tis a heavy burden in such troubled times as these.@");
  				add(["troubled times"]); 

			case "heal"(remove):
				say("Lord British waves his hand, and your whole party is healed!");
				var targets = getFriendlyTargetList(item, 25);
				for (npc in targets)
				{
					npc->clear_item_flag(PARALYZED);
					npc->clear_item_flag(POISONED);
					var str = npc->get_npc_prop(STRENGTH);
					var hps = npc->get_npc_prop(HEALTH);
					npc->set_npc_prop(HEALTH, (str - hps));
					UI_play_sound_effect(64);
				}
				add(["thanks"]);

			case "repeat"(remove):
				say("@The vast underworld from which thou didst rescue me hath collapsed. Yet still there are forces of evil abroad in the land.@*");
				say("@Britannia is under attack by gargoyles such as those thou just fought. They have been coming up through the dungeons.@*");
				say("@Thus far they have mainly been attacking the shrines of the eight virtues.@*");
				say("@When the Shrine of Compassion didst fall, Sir Geoffrey sent a party to free it. Do thou ask him of this mission. Perhaps thou canst prove of some assistance.@");
				say("@Whilst thou art here, I have a room in the castle set aside for thy personal use. 'Tis in the west wing of the castle, just south of mine own chambers. I have had my servants place some equipment there, in case thou shouldst have need of it.@**");
				say("@Of course, thou mayst feel free to borrow anything in my castle, if thou shouldst need it.@");
				say("@Lastly, any time thou dost need healing, do thou but ask me. If thou doth wish me to repeat all this later thou need but ask.@");
				add(["Geoffrey", "shrines", "virtues", "Shrine of Compassion"]);
				
			case "troubled times"(remove):
				say("@The gargoyles art indeed the greatest threat our realm has ever known.@*");
				say("@We are fortunate indeed that fate hath brought thee here in our hour of need.@");
				add(["gargoyles"]);

			case "gargoyles"(remove):
				say("@Perhaps thou canst drive these vile creatures back into the bowels of the earth from whence they came.@*");
				say("@All our efforts thus far have availed us naught.@");
				
			case "shrines"(remove):
				say("@By now the gargoyles may have captured them all.@*");
				say("@Thou must hurry if thou wouldst foil their evil schemes...@");
				add(["runes"]);

			case "virtues"(remove):
				say("@Stay strong in thy commitment to the eight virtues.@*");
				say("@It is our belief in them that sets us apart from the cruel invaders who would destroy all that we hold dear.@");
				
			case "Geoffrey"(remove):
				say("@He is the Captain of the Guard.@");
				
			case "orb"(remove):
				say("You show Lord British the black stone.*");
				say("@Hmmmm... I have such a stone, as thou may recall. I did not know that there were more such orbs.@*");
         		say("@'Twill serve thee well in thy travels if thou dost learn to master its powers.@*"); 
				say("@To open a gate, use the stone, and carefully position it a few feet from thee.@");
         		say("@Thou wilt discover that the placement is the key. In the proper positions, the stone canst conjure gates to take thee to numerous destinations.@");
  				if (!gflags[ASKED_LB_ABOUT_ORB]) //Can use orb now
					gflags[ASKED_LB_ABOUT_ORB] = true;
				

			case "runes"(remove):
				say("@Ask the leaders of each town to tell thee of that.@");
				
			case "Shrine of Compassion"(remove):
				say("@Do thou ask Tholden.@");
				add(["Tholden"]);

			case "Tholden"(remove):
				say("@He is my chancellor.@");
				add(["chancellor"]);

			case "chancellor"(remove):
				say("@Aye, Tholden is my chancellor.@");
				
			case "Sherry"(remove):
				if (inParty(SHERRY))
				{
					say("@Please take good care of my little friend.@");
				}				
				else 
				{
					say("@Ah, thou hast heard of my little friend? Her name is Sherry, and I'm quite proud of her.@*");
				    say("@I'm certain she is the only talking mouse in all of Britannia. Thou art welcome to see her, if thou dost wish. Thou canst find her wandering throughout the castle.@*");
				    say("@She comes by my room every night, so I can tell her stories.@");
					add(["stories", "book"]);
				}


			case "book"(remove):
				say("@I collect rare books. There's one in particular I've been hunting for many years.@*");
				say("@It's called 'The Wizard of Oz.' Ever heard of it?@");
				if(askYesNo())
				{
					 say("@I hath promised a great reward to whosoever shalt bring me a copy. If thou dost run across it in thy travels, I would greatly appreciate if thou couldst bring it here.@");
				}
				else say("@Well, I hath promised a great reward to whosoever shalt bring me a copy.@");
				add(["Wizard of Oz"]);

			case "Wizard of Oz"(remove):
				if (UI_count_objects(PARTY, SHAPE_BOOK, QUALITY_OZ, FRAME_ANY) >= 1 && !gflags[FOUND_OZ_BOOK])
				{
					if (UI_add_party_items(10, SHAPE_GEMS, QUALITY_ANY, 0, true))
					{
						UI_remove_party_items(10, SHAPE_GEMS, QUALITY_ANY, 0, true);
						say("@Thou hath found a copy!@*");
						say("@Long hath I anticipated this moment...@*");
						say("@Not since my childhood have I read this wondrous story.@");
						say("Gingerly, he takes the tome. @Here is your reward.@ He gives you some glowing gems.");
						UI_remove_party_items(1, SHAPE_BOOK, QUALITY_OZ, FRAME_ANY, true);	
						gflags[FOUND_OZ_BOOK] = true;
						var count = 0;
						
						
						while (count < 10)
						{
							rand = UI_get_random(11);
							UI_add_party_items(1, SHAPE_GEMS, QUALITY_ANY, rand);	
							count += 1;
							
						}
						giveExperience(100);				
					}
					else say("@Thou art carrying too much for me to reward thee properly...Bring the book back later, when thou art less burdened.@");
				}
				else say("@I collect rare books.@");

			case "stories"(remove):
				say("@My favorite story is 'Hubert the Lion.'@");
				add(["Hubert the Lion"]);

			case "Hubert the Lion"(remove):
				say("@I've known it by heart, ever since I heard it as a child.@*");
				say("@Hubert the Lion was haughty and vain, and especially proud of his elegant mane.@*");
				say("@But conceit of this sort is not proper at all, and Hubert the Lion was due for a fall.@");
			
			case "Mr. Nose"(remove):
				say("@Who told thee of that nickname!?@*");
				say("@Well, I'd rather thou didst not call me that.@");

			case "thanks"(remove):
				say("@'Tis I who should thank thee, Avatar, for all thou hast done for Britannia.@");
				
			case "Chuckles"(remove):
				say("@Chuckles? Hast thou seen him? I do hope nothing hath happened to him, he hasn't been around lately...@");
				
			case "tell Chuckles' secret"(remove):	
				say("You break your promise to Chuckles and explain to Lord British that Chuckles usurped his power during his absence, hid Lucy's death from him and hid his association with Drudgeworth.");
				say("Lord British looks incredulous.  @Avatar, those are pretty serious accusations. How dost thou know of this, is there proof?@");
				if (UI_count_objects(PARTY, SHAPE_SCROLL, QUALITY_LEAFLET, FRAME_ANY) > 0)
				{
					AVATAR.say("@I have the proof in this leaflet right here, milord.@"); 
					AVATAR.hide();
					say("Lord British reads the leaflet and furrows his brow. @This is definitely not my handwriting but it its my stationary. Conspiring to keep this secret from me for all those years...@");
					say("@..and wenching! Such lewd behavior is inappropriate for members of my royal court. That poor girl.@");
					say("He sighs. @I must have a talk with Chuckles over this. What else shall you have me do, after all these years? And why now, bring it to my attention when we have more pressing matters such as the gargoyle invasion?@");
					say("@" + player_name + ", I knowest Honesty is one of the virtues and all..@");
					say("@but really Avatar...@");
					say("@..thou musn't tattle.@");
					subtractKarma(15);
					gflags[TATTLED_ON_CHUCKLES] = true;
					if (isNearby(CHUCKLES))
					{
						delayedBark(item, "Chuckles, let us have a talk..", 3);
						delayedBark(CHUCKLES, "..I can explain!!", 6);	
					}	
					else
						delayedBark(item, "Chuckles.. I must speak with thee!", 3);
				}
				else
					say("@Well Avatar, where is it? Why are you wasting time with wild accusations while the gargoyles are running amok?@");
				break;
				
				
				
			case "bye":
				avatar_goodbye = "@Farewell, my liege.@";
				npc_goodbye = "@May fortune favor thee.@";
		
				
				//function that is called, do not change this:
				sayGoodbye(item, npc_goodbye, avatar_goodbye);
				break;
	
		}                               
	}
	else scheduleBarks(item);
}