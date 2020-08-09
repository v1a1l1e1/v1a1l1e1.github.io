#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>
/* -- outside cave -- */

outsideCave : OutdoorRoom 'Parser Valley' 'Parser Valley'
  "To the north stretches the broad green Parser Valley under a clear blue sky, past a small car park lying just off to the east. The main feature of interest round here is the notorious Eerhtsdat Caves, the entrance to which lies just to the south, marked by a large blue sign that proclaims, predictably enough:\b<CENTER><FONT FACE='TADS-Typewriter' BGCOLOR=YELLOW COLOR=BLUE> ENTRANCE TO THE\nEERHTSDAT CAVES</FONT></CENTER>\n"
  atmosphereList : ShuffledEventList {
   [
     '\nA flight of birds disappears off to the west. ',
     {: "\nA <<one of>>small<<or>>large<<at random>>
       <<one of>>green<<or>>red<<or>>blue<<or>>black<<or>>white<<at random>> car
       pulls out of the car park and drives off to the north. " },
     '\nAn aeroplane flies far overhead. ',
     nil
   ]
   }
	 north : FakeConnector { "You start to stride off into the valley, but soon decide it's not that interesting, so you wander back towards the cave entrance. " }
   south = entranceTunnel
   in asExit(south)
   east : FakeConnector { "You go and wander round the car park for a few minutes, but decide you don't want to leave just yet, so you return to the cave entrance. " }
	 ;

+ Enterable ->entranceTunnel 'eerhtsdat cave/entrance/caves' 'cave'
	   "The entrance to the cave is large and welcoming; two large people could easily walk in side by side without stooping. "
	 ;

/* -- entrance cave -- */

entranceCave: Room 'Entrance Cave' 'the entrance cave'
	"Compared with the narrow tunnel leading out to the north, this rough-walled cave seems positively spacious. A red sign fixed to one wall suggests that the narrow tunnel is the only way back out to the valley, while a blue sign next to it welcomes you to the cave. Directly under the signs a narrow ledge has been carved into the wall. There appear to be no other caves at this level, but a sturdy steel ladder leads down through a large round hole in the floor."
	north = entranceTunnel
	out asExit(north)
	down = downLadder
;

+ downLadder: StairwayDown 'sturdy steel ladder' 'sturdy steel ladder' "The ladder leads down through a large hole in the floor. "
;
+ ThroughPassage 'large hole' 'large hole'
	"The hole is easily large enough for even a portly giant to pass through.
	Looking through it you can see a large, rough cave below, lit by the flickering flame of a torch. "
	dobjFor(LookThrough) asDobjFor(Examine)
	dobjFor(TravelVia) remapTo(TravelVia, downLadder)
;
+ ThroughPassage 'narrow tunnel' 'narrow tunnel'
 	"The tunnel evidently tapers from the outside to the inside, since the end of the tunnel visible from here is quite narrow. "
	dobjFor(TravelVia) remapTo(TravelVia, entranceTunnel)
;

entranceTunnel : RoomConnector
  room1 = entranceCave
  room2 = outsideCave
  blocked = nil
  canTravelerPass (traveler) { return !blocked; }
  explainTravelBarrier (traveler)
  {
    "After a few paces down the tunnel it becomes all too clear that it has been blocked by a recent rockfall, so there is nothing for it but to turn round and go back. ";
  }
;

/* -- main cave -- */

mainCave : Room 'Large Cave'
	"The flickering orange light from the blazing torch fixed to the wall accentuates the naturally ruddy hues of this large, irregular cave, which seems to be something of a major hub in the cave system. A large rock rests against the wall to the north, other caves lie through an archway to the east and an opening to the south, while <<boulder.moved ? 'a passage has been opened up to the west' : 'the way west is blocked by a huge boulder'>>. A sturdy steel ladder leading upwards. "
	up = upLadder
	north = rock
	south = anotherCave
	west : OneWayRoomConnector {
		-> roundCave
		canTravelerPass(traveler) {return boulder.moved;}
		explainTravelBarrier(traveler) {"The huge boulder is in the way. ";}
	}
	east = squareCave
;
+ upLadder : TravelWithMessage, StairwayUp, StopEventList -> downLadder 'sturdy steel ladder' 'sturdy steel ladder'
	"The ladder leads up through a hole in the ceiling. "
	eventList = [
	new function {
			"As you climb the ladder you hear what sounds like a thounderous rockfall up above. ";
			entranceTunnel.blocked = true;
		}, 'You climb the ladder again. '
	]
;
+ rock: SecretDoor 'large rock' 'rock'
	"A large rock <<isOpen? 'lies to one side of the passage beyond' : 'leans against the north wall of the cave'>>. "
	dobjFor(Push){
		verify(){}
		action(){
			makeOpen(!isOpen);
			"The rock rolls aside. ";
		}
	}
;
+ boulder : Thing 'boulder' 'boulder'
  initDesc = "The huge boulder is blocking the exit to the west. "
;
+ EntryPortal ->squareCave 'arch/archway' 'archway'
  "It's a large archway, leading to another cave beyond. "
;

/* -- secret passage -- */

secretPassage : Room 'Secret Passage' 'the secret passage'
	"This hiterto secret passage narrows to a long tunnel running north. To the south <<rock2.isOpen? 'an opening leads out into a large, ruddy-hued cave' : 'a large rock blocks the way out'>>. "
	south = rock2
	north = tunnel
	brightness = (rock2.isOpen? 3: 0)
;

+ rock2: SecretDoor -> rock 'large rock' 'large rock'
	"It's a large rock, too heavy to lift. "
	dobjFor(Push){
		verify(){}
		action(){
			makeOpen(!isOpen);
			"The rock rolls aside. ";
		}
	}
;

+ tunnel : TravelWithMessage, ThroughPassage
	'tunnel' 'tunnel'
	"The dark tunnel looks large enough for a single person to walk through. "
	travelDesc = "You walk down the tunnel for some way and finally arrive in a small cave. "
	destination = smallCave
;

/* -- small cave -- */

smallCave: DarkRoom 'Small Cave' 'teh small cave'
	"The long narrow tunnel from the south comes to an end in this cramped, sandy-floored cave, whose rough rocky walls press in claustrophobically on every side. Anyone much taller than average would have to stop here. "
	south : TravelMessage {
		-> secretPassage
		"You walk south for quite some way down a long tunnel. ";
	}
;

/* -- another cave -- */

anotherCave: Room 'Another Cave'
  "There's something artificial about this cave. It's almost as if it's trying to be a room. The floor is suspiciously level, the walls are almost smooth, and there's a smart new door set into the south wall, with a bright electric light mounted above it. The rougher, larger central cave lies to the north. "
   north = mainCave
	 south = lakeDoor
;
+lakeDoor : Door 'smart new door' 'smart new door'
;

/* -- lake shore -- */

lakeRoom: Room 'Lake Shore'
	"This is the northern shore of a giant underground lake. A door leads north, and a path runs a short way east. "
	north = lakeDoor2
	south : NoTravelMessage {"You never learnt to walk on water. "}
	southeast asExit(south)
	southwest asExit(south)
	east = lakePath
	;

+lakeDoor2 : Door -> lakeDoor 'door' 'door'
	;
+lakePath : PathPassage
	'short eastward rocky lakeside path'
	'short lakeside path'
	"The rocky path runs a short way along the side of the lake. "
;

/* -- path end -- */

pathEnd : OutdoorRoom 'End of Lakeside Path' 'the end of the path'
  "The path from the west comes to an end just here, on the northern shore of the great underground lake. "
   west = lakePath2
   south : NoTravelMessage { "The lake is in the way. " }
;
+ lakePath2 : PathPassage ->lakePath
	'westward lakeside path'
	'westward path'
  "The path leads off along the shore of the lake to the west. "
;

/* -- round cave -- */

roundCave : DarkRoom 'Round Cave' 'the round cave'
	  "This round, rocky cave has a narrow exit to the east <<rug.moved ? 'and a strange square hole in the floor' : nil>>. "
	  east = mainCave
	  down = squareHole
	;

+ squareHole : TravelWithMessage, HiddenDoor 'square hole/chute' 'square hole'
	  "The hole is just about large enough for one person to fit through. A glint of something metallic can be seen just through the hole. "
	  travelDesc = "You find yourself sliding down a long, slippery metal chute. After a short ride you are ejected into another cave. "
		isOpen = (rug.moved)
	;

/* -- long cave -- */

longCave : DarkRoom 'Long Cave' 'the long cave'
	  "This long narrow cave runs from east to west between rough walls and a low ceiling. There is a large square hole in the west wall, while
	   a ladder fixed to the wall at the east end runs up to a trapdoor set in the ceiling. Some words have been crudely scratched on the south wall. "
	   west : NoTravelMessage { "You can't climb back up the chute, it's too slippery. " }
		 up = longCaveLadder
	;

+longCaveLadder : StairwayUp 'ladder' 'ladder'
	"The ladder fixed to the east wall leads up to a trapdoor in the ceiling. "
	dobjFor(TravelVia) remapTo(TravelVia, trapdoor)
;
+ trapdoor : AutoClosingDoor 'trap trapdoor/door' 'trapdoor'
	reportAutoClose = "<.p>After {you/he} energe{s} through the trapdoor, it slams shut behind {it actor/him}. "
;

+ ExitOnlyPassage -> squareHole 'square hole/chute' 'square hole'
	  "Through the square hole you can see the bottom end of the shiny metal chute, which is too slippery to climb back up. "
	;

/* -- square cave -- */

squareCave : DarkRoom 'Square Cave' 'the square cave'
	"This capacious cave is unnaturally square, suggesting that it has been artificially hewn out of the rock, an impression further enhanced by the carefully-constructed ashlar archway to the west. "
	 west = mainCave
	 out asExit(west)
;
+ ExitPortal -> mainCave 'ashlar arch/archway' 'archway'
  "The archway is beautifully constructed from dressed stones. "
;
+ ExitOnlyPassage -> trapdoor 'trap trapdoor/door' 'trapdoor'
	"You can hardly see the trapdoor from this side, and there is no means to pull it open. "
	;
