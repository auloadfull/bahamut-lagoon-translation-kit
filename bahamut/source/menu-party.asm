namespace menu {

seek(codeCursor)

namespace party {
  enqueue pc

  //shared
  seek($ee806d); jsl dragonName
  seek($ee7f3e); jsl playerName
  seek($ee7f79); jsl playerLevel
  seek($ee7f90); jml playerStatus
  seek($ee7fa3); jsl playerClass
  seek($ee7fef); jsl hp.setValue
  seek($ee7123); string.hook(mp.setTypeMP)  //"MP" text
  seek($ee7130); string.hook(mp.setTypeSP)  //"SP" text
  seek($ee716f); jsl mp.setValue
  seek($ee714f); jsl mp.setNone
  seek($ee7f5c); string.skip()  //"LV" text
  seek($ee7fd0); string.skip()  //"HP" text

  // Near EN layout only: widened proportional 4bpp summary positions.
  // KO JP layout disabled: preserve the Japanese ROM's original 8x8-grid coordinates.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee7f31); lda #$0040     //name position
    seek($ee7f42); lda #$004e     //"LV" clear position
    seek($ee7f6c); lda #$004e     //"LV" text position
    seek($ee7f8a); lda #$00c0     //class position
    seek($ee7fe2); lda #$0140     //"HP" position
    seek($ee8000); lda #$014c     //"MP"/"SP" position
    seek($ee7df8); lda #$0016     //X cursor offset (command menu)
    seek($ee7df1); adc #$003d     //Y cursor offset (command menu)
    seek($ee7a7e); lda #$007e     //X cursor offset (player menu)
    seek($ee7a78); adc #$0021     //Y cursor offset (player menu)
  }

  //sprite X positions
  // Near EN layout only: sprite X positions shifted for the widened party summary.
  // KO JP layout disabled: keep original player sprite X positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee671c); db $64  //player 1
    seek($ee6720); db $64  //player 2
    seek($ee6724); db $64  //player 3
    seek($ee6728); db $64  //player 4
  }

  //campaign
  seek($ee8339); string.hook(formation)
  seek($ee834c); string.hook(dragons)
  seek($ee8379); string.hook(information)
  seek($ee838e); string.hook(equipment)
  seek($ee839f); string.hook(viewMap)
  seek($ee83b0); string.hook(sortie)
  seek($ee83c3); jsl sideQuestSetup; nop #8
  seek($ee7bd7); jml sideQuestCheck; nop
  seek($ee83d5); string.hook(sideQuest)
  seek($ee835f); string.hook(autoFormation)
  seek($ee7b9b); string.hook(formationSet)  //first line
  seek($ee7bb6); string.skip()              //second line

  //sortie
  seek($ee81b5); string.hook(magic)
  seek($ee81c6); string.hook(item)
  seek($ee81d9); string.hook(equipment)
  seek($ee81ea); string.hook(information)

  //"Chapter"#
  seek($ee8287); string.skip()      //label
  seek($ee82a4); jsl chapterNumber  //value
  // Near EN layout only: campaign info value/label positions.
  // KO JP layout disabled: preserve the Japanese 8x8-grid positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee829a); lda #$06c2       //position
  }

  //"Side Quest"#
  seek($ee8262); string.skip()        //label
  seek($ee8281); jsl sideQuestNumber  //value
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee8273); lda #$06c2         //position
  }

  //"Turn"#
  seek($ee81ff); string.skip()  //label
  seek($ee82b9); jsl turn       //value
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee82af); lda #$0744   //position
  }

  //"Piro"#
  seek($ee821a); string.skip()  //label
  seek($ee82d2); jsl piro       //value
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee82bd); lda #$07c6   //position
  }

  //"Time"
  seek($ee823b); string.skip()        //time field separators
  seek($ee82dc); jsl time; jmp $8312  //value
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee82d6); lda #$0842         //position
  }

  dequeue pc

  allocator.bpp4()
  allocator.create(7, 8,name)
  allocator.create(2, 8,levelLabel)
  allocator.create(2, 8,levelValue)
  allocator.create(8, 8,class)
  allocator.create(3, 8,hpLabel)
  allocator.create(5, 8,hpValue)
  allocator.create(3, 8,mpLabel)
  allocator.create(3, 8,mpValue)
  allocator.bpp2()
  allocator.create(8,11,menu)
  allocator.create(5, 2,party)
  allocator.create(8, 2,dragon)
  allocator.create(4, 1,turnLabel)
  allocator.create(4, 1,piroLabel)
  allocator.create(7, 1,chapterLabel)
  allocator.create(2, 1,chapterValue)

  macro appendGridInteger2() {
    // USER_KO_TUNING: pixel-level numeric padding for the Near-tuned KO layout.
    if KO_USER_KO_TUNING {
      cmp.w #10; bcs render{#}
      append.alignSkip(2)
    }
  render{#}:
    append.integer_2()
  }

  macro appendGridInteger3() {
    // USER_KO_TUNING: pixel-level numeric padding for the Near-tuned KO layout.
    if KO_USER_KO_TUNING {
      cmp.w #100; bcs render{#}
      cmp.w  #10; bcs skip2{#}
      append.alignSkip(4); bra render{#}
    skip2{#}:
      append.alignSkip(2)
    }
  render{#}:
    append.integer_3()
  }

  macro appendGridInteger4() {
    // USER_KO_TUNING: pixel-level numeric padding for the Near-tuned KO layout.
    if KO_USER_KO_TUNING {
      cmp.w #1000; bcs render{#}
      cmp.w  #100; bcs skip2{#}
      cmp.w   #10; bcs skip4{#}
      append.alignSkip(6); bra render{#}
    skip4{#}:
      append.alignSkip(4); bra render{#}
    skip2{#}:
      append.alignSkip(2)
    }
  render{#}:
    append.integer_4()
  }

  inline static(define name) {
    function {name} {
      enter
      ldy.w #strings.bpp2.{name}
      lda #$0008; allocator.index(menu)
      write.bpp2(lists.strings.bpp2)
      leave; rtl
    }
  }
  static(formation)
  static(dragons)
  static(information)
  static(equipment)
  static(viewMap)
  static(sortie)
  static(sideQuest)
  static(autoFormation)
  static(formationSet)
  static(magic)
  static(item)

  //------
  //ee83bf  lda $7e801c  ;load chapter#
  //ee83c3  cmp #$0006   ;side quests are available from chapter 6 onward
  //ee83c6  bcc $83e2    ;if at chapter 5 or earlier, don't draw "Side Quest" label
  //ee83c8  lda #$2000   ;draw "Side Quest" using white text palette
  //ee83cb  sta $001862  ;store attributes value
  //......               ;draw "Side Quest" label
  //ee83e2  plb
  //ee83e3  plp
  //ee83e4  rtl
  //------
  //A => chapter#
  function sideQuestSetup {
    php; rep #$20; pha
    cmp #$0006; bcc +  //prologue + chapters 1-5 lack side quests
    cmp #$001c; bcs +  //side quests themselves lack side quests (debugger fix)
    tilemap.setColorWhite(); pla; plp; rtl
  +;tilemap.setColorGray();  pla; plp; rtl
  }

  //------
  //ee7bd3  lda $7e801c  ;load chapter#
  //ee7bd7  cmp #$0006   ;side quests are available from chapter 6 onward
  //ee7bda  bcs $7be5    ;if at chapter 6 or later, enter side quest menu
  //------
  //A => chapter#
  function sideQuestCheck {
    php; rep #$20; pha
    cmp #$0006; bcc +      //prologue + chapters 1-5 lack side quests
    cmp #$001c; bcs +      //side quests themselves lack side quests (debugger fix)
    pla; plp; jml $ee7be5  //enter side quest menu
  +;pla; plp; jml $ee7bdc  //do not enter side quest menu
  }

  //A => party
  function party {
    enter
    tilemap.setColorWhite()
    and #$0007; mul(5); tay
    lda #$0005; allocator.index(party); write.bpp2(lists.parties.bpp2)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => dragon
  function dragonName {
    enter
    getDragonName(); jsl koName.renderDefaultToNameBufferBpp2
    mul(8); tay
    lda #$0008; allocator.index(dragon); write.bpp2(names.buffer.bpp2)
    leave; rtl
  }

  //A => chapter#
  function chapterNumber {
    enter
    tilemap.setColorGreen()
    and #$001f; pha
    ldy.w #strings.bpp2.chapterLabel
    lda #$0007; allocator.index(chapterLabel); write.bpp2(lists.strings.bpp2)
    pla; mul(2); tay
    lda #$0002; allocator.index(chapterValue); write.bpp2(lists.quantities.bpp2)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => chapter#
  function chapterName {
    enter
    and #$001f; mul(8); tay
    lda #$0008; ldx #$0010
    write.bpp2(lists.chapters.bpp2)
    leave; rtl
  }

  //A => side quest#
  function sideQuestNumber {
    php; rep #$30; pha
    add #$001b; jsl chapterName
    pla; plp; rtl
  }

  //A => turn#
  function turn {
    enter; ldx #$0000
    append.integer03()
    lda #$0003; render.small.bpp2()
    ldx #$0018; jsl write.bpp2
    tilemap.incrementAddress(2)
    ldy.w #strings.bpp2.turnLabel
    lda #$0004; allocator.index(turnLabel); write.bpp2(lists.strings.bpp2)
    leave; rtl
  }

  //$7e8016-$7e8018 => piro
  function piro {
    enter; ldx #$0000
    lda $7e8018; and #$00ff; tay
    lda $7e8016
    append.integer10()
    lda #$0006; render.small.bpp2()
    //KO: JP starts this row two tiles further left (aligned under CHAPTER).
    //Shift the tilemap position once here - the label written after the value
    //follows the advanced address, so both move together. (X in write.bpp2 is
    //the VRAM source tile index, not a position: changing it corrupts digits.)
    tilemap.incrementAddress($fffc)
    lda render.tiles
    ldx #$001e; jsl write.bpp2
    ldy.w #strings.bpp2.piro
    lda #$0004; allocator.index(piroLabel); write.bpp2(lists.strings.bpp2)
    leave; rtl
  }

  //$7e3bd0 => hour
  //$7e3bd1 => minute
  //$7e2bd2 => second
  function time {
    enter; ldx #$0000
    lda $7e3bd0; and #$00ff
    cmp.w #100; bcs digits_3
    append.integer02()
    append.literal(":")
    lda $7e3bd1; and #$00ff
    append.integer02()
    append.literal(":")
    lda $7e3bd2; and #$00ff
    append.integer02()
    lda #$0008; render.small.bpp2()
    ldx #$0027; jsl write.bpp2
    leave; rtl

  digits_3:
    append.integer_3()
    append.literal(":")
    lda $7e3bd1; and #$00ff
    append.integer02()
    append.literal(":")
    lda $7e3bd2; and #$00ff
    append.integer02()
    lda #$0009; render.small.bpp2()
    ldx #$0027; jsl write.bpp2
    leave; rtl
  }

  //A => player name
  function playerName {
    enter
    and #$00ff
    cmp #$0009; jcs static
  dynamic:
    jsl koName.renderDefaultToNameBufferBpp4
    mul(8); tay
    lda #$0007; allocator.index(name); write.bpp4(names.buffer.bpp4)
    leave; rtl
  static:
    mul(8); tay
    lda #$0007; allocator.index(name); write.bpp4(lists.names.bpp4)
    leave; rtl
  }

  //A => player level
  function playerLevel {
    variable(2, value)

    enter
    and #$00ff; sta value
    tilemap.setColorGreen()
    ldx #$0000; append.literal("LV")
    lda #$0002; render.small.bpp4()
    lda #$0002; allocator.index(levelLabel); write.bpp4()
    tilemap.setColorWhite()
    lda value; and #$00ff; min.w(100); mul(3); inc; tay
    lda #$0002; allocator.index(levelValue); write.bpp4(lists.levelsMagic.bpp4)
    leave; rtl
  }

  //draw status ailments and/or enchantments.
  //if there are none, then draw the player class name instead.
  function playerStatus {
    ldy #$0008; lda [$44],y; and.w #status.ailment.mask; beq +; jml $ee7fb3; +
    ldy #$000a; lda [$44],y; and.w #status.enchant.mask; beq +; jml $ee7fb3; +
    jml $ee7f9c
  }

  //A => player class
  function playerClass {
    enter
    and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp4(lists.classes.bpp4)
    leave; rtl
  }

  namespace hp {
    variable(2, value)

    function setValue {
      enter
      sta value
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(hpLabel); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000; lda value
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      appendGridInteger4(); +
      append.literal(" ")
      lda #$0005; render.small.bpp4()
      lda #$0005; allocator.index(hpValue); write.bpp4()
      leave; rtl
    }
  }

  namespace mp {
    variable(2, type)  //0 = MP, 1 = SP
    variable(2, value)
    variable(2, counter)

    setTypeMP:; php; rep #$20; pha; lda #$0000; sta type; pla; plp; rtl
    setTypeSP:; php; rep #$20; pha; lda #$0001; sta type; pla; plp; rtl

    function renderLabel {
      enter
      tilemap.setColorGreen()
      ldx #$0000
      lda type
      cmp #$0001; beq sp
    mp:
      append.literal("MP:")
      bra render
    sp:
      append.literal("SP:")
    render:
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(mpLabel); write.bpp4()
      leave; rtl
    }

    function setValue {
      enter
      sta value
      jsl renderLabel
      tilemap.setColorWhite()
      ldx #$0000; lda value
      cmp #$ffff; bne +; append.literal("---"); bra render; +
      cmp #$03e8; bcc +; append.literal("???"); bra render; +
      appendGridInteger3()

    render:
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(mpValue); write.bpp4()
      leave; rtl
    }

    function setNone {
      enter
      // USER_KO_TUNING: unavailable MP/SP rows use the far-right stat slot,
      // not the normal MP/SP label origin.  Keep the newly restored "MP:/SP:"
      // label, but shift the whole unavailable block two tiles right.
      if KO_USER_KO_TUNING {
        tilemap.incrementAddress(4)
      }
      jsl renderLabel
      tilemap.setColorWhite()
      ldx #$0000; append.literal("---")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(mpValue); write.bpp4()
      leave; rtl
    }
  }
}

codeCursor = pc()

}
