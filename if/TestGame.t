#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID
	name = 'Test Game'
	byLine = 'by Valentina'
	version = '1'
;

gameMain: GameMainDef
	initialPlayerChar = me
	showIntro(){
		"Finding yourself at a loose end in the Parser Valley, you have wandered up to take a look at the famous Eerhtsdat Caves. You're not entirely sure what they're famous for, or why they should be worth a look, but that's what it said the guidebook you found abandoned on the back seat of the bus, so it must be true. Anyway, you're here now, so you reckon you may as well take a look.\b";
	}
	setAboutBox()
{
	"<ABOUTBOX><CENTER>Test Game\b
	 v <<versionInfo.version>>\b
	 (c) Valentina\b
	 </CENTER></ABOUTBOX>";
}
showGoodBye()
{
	"<.p>Thanks for playing!";
}
;

me: Actor
	location = outsideCave
	bulkCapacity = 100 
;
