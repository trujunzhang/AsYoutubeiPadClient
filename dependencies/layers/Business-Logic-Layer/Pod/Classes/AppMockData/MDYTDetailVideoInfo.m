//
// Created by djzhang on 12/12/14.
// Copyright (c) 2014 djzhang. All rights reserved.
//

#import "MDYTDetailVideoInfo.h"
#import "YoutubeParser.h"


@implementation MDYTDetailVideoInfo {

}

//https://www.youtube.com/watch?v=8ThQcXnW2g4
- (instancetype)init {
    self = [super init];
    if(self) {
        // line001
        self.snippet.channelTitle = @"Jean-Marc Denis";

        // line002
        self.snippet.descriptionString =
//       @"Tweet this video! - http://clicktotweet.com/vL72e\\n\\nWhether its an unsolved mystery, a popular misconception, or sometimes just a big hoax urban legends are an inevitable part of any culture. Usually they are handed down by word of mouth from generation to generation and many times have their origin in some vaguely twisted version of a true story. Regardless of their veracity, however, these are the 25 most popular urban legends still being told.\\n\\nhttps://twitter.com/list25\\nhttps://www.facebook.com/list25\\nhttp://list25.com\\n\\nCheck out the text version too! - http://list25.com/25-most-popular-urban-legends-still-being-told/\\n\\nHere's a preview: \\n\\nMr. Rogers was a Navy SEAL\\nBloody Mary\\nKennedy and the Jelly Donut\\nThe Dissolving Tooth\\nThe Good Samaritan\\nWalt Disney is Cryogenically Frozen\\nSewer Gators\\nThe Vanishing Hitchhiker\\nThe Kidney Heist\\nThe Killer in the Backseat\\nBabysitter and the Man Upstairs\\nHumans Can Lick Too\\nAren't You Glad You Didn't Turn On The Light?\\nThe Jedi Religion Form\\nSnuff Films\\nThe 9/11 Tourist Guy\\nUSA, Japan\\nThe Poisonous Daddy Long Legs\\nThe Hook\\nThe Boyfriend's Death\\nThe Clown Statue\\nThe Fatal Hairdo\\nDead Body Under The Mattress\\nThe Halloween Hanging\\nBuried Alive";
//       @"Tweet this video! - http://clicktotweet.com/vL72e  Whether its an unsolved mystery, a popular misconception, or sometimes just a big hoax urban legends are an inevitable part of any culture. Usually they are handed down by word of mouth from generation to generation and many times have their origin in some vaguely twisted version of a true story. Regardless of their veracity, however, these are the 25 most popular urban legends still being told.  https://twitter.com/list25 https://www.facebook.com/list25 http://list25.com  Check out the text version too! - http://list25.com/25-most-popular-urban-legends-still-being-told/  Here's a preview:   Mr. Rogers was a Navy SEAL Bloody Mary Kennedy and the Jelly Donut The Dissolving Tooth The Good Samaritan Walt Disney is Cryogenically Frozen Sewer Gators The Vanishing Hitchhiker The Kidney Heist The Killer in the Backseat Babysitter and the Man Upstairs Humans Can Lick Too Aren't You Glad You Didn't Turn On The Light? The Jedi Religion Form Snuff Films The 9/11 Tourist Guy USA, Japan The Poisonous Daddy Long Legs The Hook The Boyfriend's Death The Clown Statue The Fatal Hairdo Dead Body Under The Mattress The Halloween Hanging Buried Alive";
                @"Tweet this video! - http://clicktotweet.com/vL72e\n"
                        "\n"
                        "Whether its an unsolved mystery, a popular misconception, or sometimes just a big hoax urban legends are an inevitable part of any culture. Usually they are handed down by word of mouth from generation to generation and many times have their origin in some vaguely twisted version of a true story. Regardless of their veracity, however, these are the 25 most popular urban legends still being told.\n"
                        "\n"
                        "https://twitter.com/list25\n"
                        "https://www.facebook.com/list25\n"
                        "http://list25.com\n"
                        "\n"
                        "Check out the text version too! - http://list25.com/25-most-popular-urban-legends-still-being-told/\n"
                        "\n"
                        "Here's a preview: \n"
                        "\n"
                        "Mr. Rogers was a Navy SEAL\n"
                        "Bloody Mary\n"
                        "Kennedy and the Jelly Donut\n"
                        "The Dissolving Tooth\n"
                        "The Good Samaritan\n"
                        "Walt Disney is Cryogenically Frozen\n"
                        "Sewer Gators\n"
                        "The Vanishing Hitchhiker\n"
                        "The Kidney Heist\n"
                        "The Killer in the Backseat\n"
                        "Babysitter and the Man Upstairs\n"
                        "Humans Can Lick Too\n"
                        "Aren't You Glad You Didn't Turn On The Light?\n"
                        "The Jedi Religion Form\n"
                        "Snuff Films\n"
                        "The 9/11 Tourist Guy\n"
                        "USA, Japan\n"
                        "The Poisonous Daddy Long Legs\n"
                        "The Hook\n"
                        "The Boyfriend's Death\n"
                        "The Clown Statue\n"
                        "The Fatal Hairdo\n"
                        "Dead Body Under The Mattress\n"
                        "The Halloween Hanging\n"
                        "Buried Alive";

        [YoutubeParser parseDescriptionStringWithRegExp:self];
    }

    return self;
}


- (instancetype)init111 {
    self = [super init];
    if(self) {
        // line001
        self.snippet.channelTitle = @"Jean-Marc Denis";

        // line002
        self.snippet.descriptionString =
                @"Thus tutorial shows you how to set up repeat reminders using a combination of OmniFocus, "
                        "Keyboard Maestro and Due App. \n"
                        "Note that there’s been a slight alteration to the macro as the date wasn’t parsing properly. \n"
                        "This has now been fixed in the download.\n\nThe link to the Keyboard Maestro Macro is below.\n"
                        "\n\nhttp://bit.ly/DLOF2KBMM\n\n("
                        "You will need to remove the .txt from the end of the filename so that KBM will recognise it as a macro"
                        ")\n\nHelp us caption & translate this video!\n\nhttp://amara.org/v/F06M/"
                        "According to a living-e rep they are considering adding an option to store the password in the keychain:\n"
                        "http://forum.webedition.de/phpBB/viewtopic.php?f=4&t=5517&p=12019\n"
                        "Update: I pestered Living-e support and got them to add it as a feature request to their bug tracker. \n"
                        "The link is here: http://qa.living-e.de/tracker/view.php?id=3648 (requires registration) \n"
                        "if you want to follow it.\n"
                        "Another update: Still following this issue.\n "
                        "Looks like living-e moved their bug tracker, the new link to this issue is:\n"
                        "http://bugs.mamp.info/view.php?id=3652\n"
                        "It's in German but the Google translation";

        NSString *debug = @"debug";
    }

    return self;
}


@end