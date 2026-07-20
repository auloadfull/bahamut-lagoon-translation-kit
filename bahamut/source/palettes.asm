namespace palette {

constant white   = color(31,31,29)
constant gray    = color(15,15,15)
constant black   = color( 2, 2, 2)
constant yellow  = color(30,30, 2)
constant combatGold = color(31,27, 0)  //KO: JP battle selected/LVUP text is warmer than pure yellow
constant shadow  = color(20,20,20)
constant green   = color(26,31,28)  //KO: sampled original cyan-green candidate 0x73fa
constant ivory   = color(31,31,15)
constant navy    = color( 2, 2,12)
constant red     = color(31,12,12)
constant silver  = color(21,21,21)
constant crimson = color(21, 8, 8)

seek(codeCursor)

namespace chapter {
  enqueue pc
  seek($e87cdd); {  //chapter cutscene text palette
    dw white   //color 1
    dw black   //color 2
    //color 3 restored to white (JP original): this palette is shared with the
    //JP-native ending credits, which inherit it for their text edge. KO had set
    //it yellow for chapter emphasis, which bled through as the ending "yellow"
    //(confirmed by a red/green/blue diagnostic). White matches the JP original
    //and clears the ending bleed; chapter emphasis text now renders white.
    dw white   //color 3
  }
  dequeue pc
}

namespace field {
  enqueue pc
  seek($c6a052); {  //add yellow and ivory text colors
    dw ivory   //color  9
    dw gray    //color 10
    dw black   //color 11
    ds 2       //color 12
    dw white   //color 13
    dw black   //color 14
    dw yellow  //color 15
  }
  dequeue pc
}

namespace combat {
  enqueue pc
  seek($c1ca4d); {  //add battle active text color
    dw white   //color 1
    dw black   //color 2
    dw combatGold  //color 3
  }
  seek($e64b42); {  //combat active small-text palette
    dw white   //color 1
    dw gray    //color 2
    dw navy    //color 3
    ds 2       //color 4
    dw combatGold  //color 5
    dw black       //color 6
  }
  dequeue pc
}

namespace menu {
  enqueue pc
  seek($ee53a4); jsl hook
  seek($ee85d2); {  //add green and ivory text colors
    dw white   //color  1
    dw gray    //color  2  //KO: item icon mid-tone; KO text shadows use color 3
    dw black   //color  3
    ds 2       //color  4
    dw shadow  //color  5
    dw black   //color  6
    dw black   //color  7
    ds 2       //color  8
    dw green   //color  9
    dw black   //color 10
    dw black   //color 11
    ds 2       //color 12
    dw ivory   //color 13
    dw black   //color 14
    dw black   //color 15
  }
  dequeue pc

  //add yellow text color and rearrange palette order
  //------
  //ee53a1  lda #$0000
  //ee53a4  sta $7e41e6
  //------
  function hook {
    php; rep #$20; pha
    lda.w #white;  sta $7e41e2  //color 1
    lda.w #black;  sta $7e41e4  //color 2
    lda.w #yellow; sta $7e41e6  //color 3
    pla; plp; rtl
  }
}

namespace titleScreen {
  //Reverted to JP-original title screen: leave the base ROM menu palettes so the
  //original "New Play / DataLoad" menu text renders in its original colors.
  //enqueue pc
  //seek($e89de0); dw black, silver,  white  //inactive menu item palette
  //seek($e89e00); dw black, crimson, red    //selected menu item palette
  //dequeue pc
}

namespace endingScreen {
  //Near's ending palette override stays disabled so the JP original loads:
  //seek($e8ddf0); insert "../en/binaries/fonts/font-ending-palette.bin"
}

codeCursor = pc()

}
