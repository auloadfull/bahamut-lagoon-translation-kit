namespace menu {

seek(codeCursor)

namespace unit {
  constant KO_UNIT_DRAGON_RELOCATE_NAME_BLOCK = 0
  constant KO_UNIT_DRAGON_FORCE_LV_ROW        = 0
  constant KO_UNIT_DRAGON_CUSTOM_HDMA         = 0
  constant KO_UNIT_DETAIL_TOP_POSITIONS       = 1
  constant KO_UNIT_CLEAR_UNUSED_DRAGON_STATS  = 0
  constant KO_UNIT_DRAGON_LOWER_JP_ALIGN      = 1
  constant KO_UNIT_PLAYER_LIST_NO_CLASS       = 1
  constant KO_UNIT_DRAGON_NAME_POS            = $0692
  constant KO_UNIT_DRAGON_LV_POS              = $0712
  constant KO_UNIT_DRAGON_HP_POS              = $0792
  constant KO_UNIT_DRAGON_MP_POS              = $0812
  constant KO_UNIT_DRAGON_NAME_ROW_DELTA      = $0000  //was $ff80 (cancelled Near's +$80 origin)
  constant KO_UNIT_DRAGON_RIGHT_LABEL_DELTA   = $0000  //was $ff80 (same reason)
  constant KO_UNIT_DRAGON_RIGHT_VALUE_DELTA   = $fffe  //was $ff7e; keeps its extra -2px
  constant KO_UNIT_DRAGON_PROPERTY_DELTA      = $0002

  enqueue pc

  seek($eeada3); jsl name
  seek($eeadbc); jsl enemy
  seek($eeac38); jsl drawWindowBG3
  //#7: render the portrait-less enemy name (Alexander) as "UNKNOWN" in the JP sky
  //accent via the KO Latin menu font (JP's own "UNKNOWN" tiles garble in the KO
  //font page, so the hook stays but draws the word with append.literal).
  seek($eeac42); string.hook(enemy.unknown)
  seek($eeadf0); jsl level
  seek($eeae29); jsl hp.setCurrent
  seek($eeae47); jsl hp.setMaximum
  seek($eeaea1); jsl mp.setCurrent
  seek($eeaebf); jsl mp.setMaximum
  seek($eeaed8); jsl mp.setCurrentUnavailable
  seek($eeaef5); jsl mp.setMaximumUnavailable
  seek($eeaf06); string.hook(attack.label)
  seek($eeaf38); string.hook(defense.label)
  seek($eeaf6a); string.hook(speed.label)
  seek($eeaf9c); string.hook(magic.label)
  seek($eeaf27); jsl attack.value
  seek($eeaf59); jsl defense.value
  seek($eeaf8b); jsl speed.value
  seek($eeafbd); jsl magic.value
  seek($eeaffe); jsl stats; jmp $affb

  //the "LV" text was moved up onto the name line.
  //the status icons have been moved to the start of the second line.
  seek($eeadd3); string.skip()  //"LV" text
  seek($eeae0a); string.skip()  //"HP" text
  seek($eeae33); string.skip()  //"HP" separator
  seek($eeae76); string.hook(mp.setTypeMP)  //"MP" text

  // Near EN layout only: unit detail label/stat positions.
  // KO JP layout disabled: keep original Japanese 8x8-grid coordinates.
  if KO_LAYOUT_NEAR_TUNED && KO_UNIT_DETAIL_TOP_POSITIONS {
    seek($eeade3); lda #$0060     //"LV" position
    seek($eeadf4); lda #$00da     //status icon(s) position
    seek($eeae3a); lda #$0150     //"HP" position

    seek($eeaf1a); lda #$0078  //"Attack#"  position
    seek($eeaf4c); lda #$00f8  //"Defense#" position
    seek($eeaf7e); lda #$0178  //"Speed#"   position
    seek($eeafb0); lda #$01f8  //"Magic#"   position
  }

  //player and dragon statistics
  seek($ee7065); string.skip()  //disable "-" separator (with MP/SP)
  seek($ee7020); string.skip()  //disable "-" separator (without MP/SP)
  // Near EN layout only: numeric offset cleanup for proportional MP/SP ranges.
  // KO JP layout disabled: preserve original numeric/dash offsets.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee705f); nop #2         //position numeric offset (dash)
    seek($ee7071); adc #$0000     //position numeric offset (maximum)
  }

  //dragon statistics (most stat strings are shared with the item explanation screen)
  seek($eeb03b); string.skip()  //"Timidity" text
  seek($eeb04c); string.skip()  //"Wisdom" text

  //enemy statistics
  seek($eeaeab); string.skip()  //disable "-" separator (with MP)
  seek($eeaee2); string.skip()  //disable "-" separator (without MP)
  // Near EN layout only: enemy/unit MP and single-enemy summary positions.
  // KO JP layout disabled: keep original Japanese positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($eeaeb2); lda #$01d0     //available position
    seek($eeaee9); lda #$01d0     //unavailable position
    seek($eead33); lda #$0642     //position of name+stats for single enemies (bosses usually)
                                  //JP original value; Near had moved it +$80 (8px down), which put
                                  //every single-boss detail a row low. The dragon detail shares this
                                  //origin, so its three runtime type-gated deltas below drop the
                                  //-$80 they used to cancel Near's shift and stay where they were.
  }

  //cursor positions
  // Near EN layout only: cursor offsets for adjusted unit-detail blocks.
  // KO JP layout disabled: preserve original Japanese cursor positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($eeac8d); lda #$0046  //X cursor position (player - from field)
    seek($eeac86); adc #$fff9  //Y cursor position
    seek($eeab00); lda #$0044  //X cursor position (dragon - from field)
    seek($eeab07); lda #$0089  //Y cursor position
    seek($eeaa2d); lda #$0044  //X cursor position (dragon - from dragon formation)
    seek($eeaa34); lda #$0089  //Y cursor position
  }

  //player statistics HDMA fix:
  //8x12 height is simulated using HDMA on channel 7 from $eeb1c7 (ROM) to $2112 (BG3VOFS)
  //the original game had a small bug in the last entry of the table:
  //$00; $04,$08,$0c,$10; $16,$1a,$1e,$22; $28,$2c,$30,$34; $3a,$3e,$42,$46; $44
  //$44 should be $4c. this error resulted in the last text line being repeated twice.
  // Near EN layout only: HDMA table byte patch for the replaced 8x12 layout.
  // KO JP layout disabled: leave the original Japanese HDMA table untouched.
  if KO_LAYOUT_NEAR_TUNED {
    seek($eeb1fb); db $4c  //this modification to the HDMA table fixes the error.
  }

  dequeue pc

  allocator.bpp2()
  allocator.create( 8, 4,name)
  allocator.create( 7, 1,unknown)  //#7: 'UNKNOWN' is 7 chars
  allocator.create( 5, 4,level)
  allocator.create( 8, 4,class)
  allocator.create(47, 1,jpNumberTileGuard)
  allocator.create(12, 4,hpRange)
  allocator.create(12, 4,mpRange)
  allocator.create( 3, 4,enemyHpLabel)
  allocator.create( 3, 4,enemyMpLabel)
  allocator.create( 3, 4,playerHpLabel)
  allocator.create( 9, 4,playerHpValue)
  allocator.create( 3, 4,playerMpLabel)
  allocator.create( 9, 4,playerMpValue)
  allocator.create( 5, 1,attackLabel)
  allocator.create( 5, 1,defenseLabel)
  allocator.create( 5, 1,speedLabel)
  allocator.create( 5, 1,magicLabel)
  allocator.create( 3, 4,attackValue)
  allocator.create( 3, 4,defenseValue)
  allocator.create( 3, 4,speedValue)
  allocator.create( 3, 4,magicValue)
  allocator.create( 6,15,propertyLabel)
  allocator.create( 3,15,propertyValue)

  namespace character {
    constant player = 0
    constant dragon = 1
    constant enemy  = 2

    variable(2, type)
  }

  variable(2, KO_UNIT_LAST_NAME_ADDR)

  //A => player or dragon name
  function name {
    variable(2, index)

    enter
    and #$00ff; sta index
    lda.w #character.player; sta character.type

    //move the name+stats position only for the dragon screens.
    //this is done to make room for the extra stats shown in the translation.
    lda index
    cmp #$0002; bcc +
    cmp #$0009; bcs +
    // Near EN layout only: adjusted dragon lower-summary tilemap origin.
    // KO JP layout disabled: preserve the caller's original Japanese tilemap origin.
    if KO_LAYOUT_NEAR_TUNED && KO_UNIT_DRAGON_RELOCATE_NAME_BLOCK {
      tilemap.setAddress($0792); tilemap.setBaseAddress($07c2)
    }
    if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
      tilemap.incrementAddress(KO_UNIT_DRAGON_NAME_ROW_DELTA)
    }
    lda.w #character.dragon; sta character.type; +

    lda index
    cmp #$0009; jcs static
  dynamic:
    lda tilemap.address
    sta KO_UNIT_LAST_NAME_ADDR
    lda index
    jsl koName.renderDefaultToNameBufferBpp2
    lda index
    mul(8); tay
    allocator.index(name)
    lda #$0008; write.bpp2(names.buffer.bpp2)
    lda character.type; cmp.w #character.dragon; bne +; jmp done; +
    if KO_UNIT_PLAYER_LIST_NO_CLASS {
      lda character.type; cmp.w #character.player; bne +; jmp done; +
    }
    jmp class
  static:
    lda tilemap.address
    sta KO_UNIT_LAST_NAME_ADDR
    lda index
    mul(8); tay
    allocator.index(name)
    lda #$0008; write.bpp2(lists.names.bpp2)
    lda character.type; cmp.w #character.dragon; bne +; jmp done; +
    if KO_UNIT_PLAYER_LIST_NO_CLASS {
      lda character.type; cmp.w #character.player; bne +; jmp done; +
    }

  class:
    //re-add the missing player/dragon class names below the character names.
    //but if there are any status icons, do not draw the class name.
    ldy #$0008; lda [$44],y; and.w #status.ailment.mask; beq +; leave; rtl; +
    ldy #$000a; lda [$44],y; and.w #status.enchant.mask; beq +; leave; rtl; +

    tilemap.incrementAddress($70)  //seek to the start of the next line
    lda index
    cmp #$0002; bcc playerClass
    cmp #$000a; bcs playerClass
    jmp dragonClass

  playerClass:
    //look up the player class
    ldy #$000c; lda [$44],y; and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp2(lists.classes.bpp2)
    leave; rtl

  dragonClass:
    //look up the dragon class
    ldy #$0006; lda [$40],y; sub #$0020; mul(32); tax
    lda $7e3bf1,x; and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp2(lists.dragons.bpp2)
    leave; rtl

  done:
    leave; rtl
  }

  //A => enemy
  function enemy {
    enter
    pha; lda.w #character.enemy; sta character.type; pla
    pha
    lda tilemap.address
    sta KO_UNIT_LAST_NAME_ADDR
    pla
    and #$00ff; mul(8); tay
    allocator.index(name)
    lda #$0008; write.bpp2(lists.enemies.bpp2)
    leave; rtl

    //shown for enemies without sprite portrait previews (eg Alexander)
    function unknown {
      enter
      tilemap.setColorGreen()   //JP sky/cyan accent
      ldx #$0000; append.literal("UNKNOWN")
      lda #$0007; render.small.bpp2()
      lda #$0007; allocator.index(unknown); write.bpp2()
      leave; rtl
    }
  }

  //A => player or enemy level
  function level {
    variable(2, value)
    variable(2, oldLevelAddress)

    enter
    pha
    lda character.type; cmp.w #character.dragon; bne normal
    jmp dragon
  normal:
    pla
    and #$00ff; sta value
    lda tilemap.address; sta oldLevelAddress
    lda character.type
    cmp.w #character.player; bne +
    jmp playerTextLevel
  +
    cmp.w #character.enemy; bne +
    jmp enemy
  +;jmp oldNormal

  enemy:
    lda oldLevelAddress
    sta tilemap.address
    tilemap.setColorWhite()
    ldy #$0005; jsl clearSpaces

    lda oldLevelAddress
    add #$0070
    sta tilemap.address
    tilemap.setColorWhite()
    ldy #$0005; jsl clearSpaces

    lda oldLevelAddress
    add #$0070
    sta tilemap.address
    tilemap.setColorGreen()
    ldx #$0000; append.literal("LV")
    lda #$0002; render.small.bpp2()
    lda #$0002; allocator.index(level); write.bpp2()

    lda oldLevelAddress
    add #$0076
    sta tilemap.address
    tilemap.setColorWhite()
    lda value
    jsl $ee4e4e
    leave; rtl

  playerTextLevel:
    lda KO_UNIT_LAST_NAME_ADDR
    add #$0080
    sta tilemap.address
    tilemap.setColorGreen()
    ldx #$0000; append.literal("LV")
    lda #$0002; render.small.bpp2()
    lda #$0002; allocator.index(level); write.bpp2()
    tilemap.setColorWhite()
    lda value
    ldx #$0000; append.alignSkip(2); append.integer_2()
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(level); inx #2; write.bpp2()
    leave; rtl

  oldNormal:
    lda value
    and #$00ff; mul(3); tay
    allocator.index(level)
    lda #$0003; write.bpp2(lists.levels.bpp2)
    leave; rtl

  dragon:
    // Near EN layout only: force adjusted dragon LV row.
    // KO JP layout disabled: preserve the caller's original Japanese LV row.
    if KO_LAYOUT_NEAR_TUNED && KO_UNIT_DRAGON_FORCE_LV_ROW {
      tilemap.setAddress($0812)
    }
    if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
      tilemap.setAddress(KO_UNIT_DRAGON_LV_POS)
    }
    tilemap.setColorGreen()
    ldx #$0000; append.literal("LV")
    lda #$0002; render.small.bpp2()
    lda #$0002; allocator.index(level); write.bpp2()
    tilemap.setColorWhite()
    pla
    ldx #$0000; append.alignSkip(2); append.integer_2()
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(level); inx #2; write.bpp2()
    leave; rtl
  }

  function appendDragonInteger4Value {
    // USER_KO_TUNING: pixel-level right alignment for the Near-tuned KO
    // dragon detail HP/MP rows. JP_BASE leaves this extra padding off.
    if KO_USER_KO_TUNING {
      cmp.w #1000; bcs render
      cmp.w  #100; bcs skip8
      cmp.w   #10; bcs skip16
      append.alignSkip(24); bra render
    skip16:
      append.alignSkip(16); bra render
    skip8:
      append.alignSkip(8)
    }
  render:
    append.integer_4()
    rtl
  }

  macro appendDragonInteger4() {
    jsl appendDragonInteger4Value
  }

  function appendUnitInteger3Value {
    cmp.w #$ffff; bne +
    append.literal("---")
    bra done
  +;cmp.w #1000; bcc valid
    append.literal("???")
    bra done
  valid:
    cmp.w #100; bcs render
    cmp.w #10; bcs twoDigits
  oneDigit:
    append.alignSkip(16)
    bra render
  twoDigits:
    append.alignSkip(8)
  render:
    append.integer5()
  done:
    rtl
  }

  macro appendUnitInteger3() {
    jsl appendUnitInteger3Value
  }

  function appendPaddedUnitRange3Value {
    phy
    append.alignSkip(8)
    jsl appendUnitInteger3Value
    append.literal("/")
    append.alignSkip(8)
    ply
    tya
    jsl appendUnitInteger3Value
    rtl
  }

  function appendEnemyHpInteger4Value {
    //#7: values past four digits (eg Alexander's hidden 50000 max HP) overflow
    //integer_4 and rendered as "0"; JP shows "????". Use '?' (character-map: $90,
    //the JP full-width mark) rather than text.asm's '^' (= $9b "en-question",
    //Near's narrow Latin glyph) so it matches the JP 8x8 digits beside it.
    cmp.w #10000; bcc +; append.literal("????"); rtl; +
    cmp.w #1000; bcs render
    append.alignSkip(2)
    cmp.w #100; bcs render
    cmp.w #10; bcc render
    pha
    dex
    lda.w #$ff04
    sta.l render.text,x
    inx
    pla
  render:
    append.integer_4()
    rtl
  }

  function appendEnemyRange4Value {
    phy
    jsl appendEnemyHpInteger4Value
    append.literal("/")
    ply
    tya
    //#7: a hidden maximum HP is stored as 0 (eg Alexander) -> draw "????" like JP.
    //NOTE: '^' is the game's glyph for '?' (see text.asm hpValue/hpRange); a
    //literal "?" is not in the menu font and renders as garbage.
    jsl appendEnemyHpInteger4Value
    rtl
  }

  //Y => number of blank tiles to write at the current tilemap address.
  function clearSpaces {
    enter; ldb #$7e
    lda tilemap.address; tax
    lda.w #glyph.space; ora tilemap.attributes
  -;cpy #$0000; beq +
    sta.w tilemap.location,x; inx #2
    dey; bra -
  +;txa; sta tilemap.address
    lda #$0001; sta tilemap.transfer
    leave; rtl
  }

  namespace hp {
    variable(2, current)
    variable(2, maximum)

    //A => current HP
    function setCurrent {
      enter
      sta current
      leave; rtl
    }

    //A => maximum HP
    function setMaximum {
      enter
      sta maximum
      lda character.type; cmp.w #character.dragon; bne +; jmp dragon; +
      cmp.w #character.player; bne +; jmp playerHpRange; +
      cmp.w #character.enemy; bne +; jmp enemyHpRange; +

    oldHpRange:
      lda maximum; tay; lda current
      ldx #$0000; append.hpRange()
      lda #$000b; render.small.bpp2()
      allocator.index(hpRange); jsl write.bpp2
      leave; rtl

    enemyHpRange:
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(enemyHpLabel); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      lda maximum; tay; lda current
      jsl appendEnemyRange4Value
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(hpRange); inx #3; write.bpp2()
      leave; rtl

    playerHpRange:
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(playerHpLabel); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      //4-digit like the dragon/enemy paths (was appendPaddedUnitRange3Value which
      //capped at 999 -> "???"). appendDragonInteger4 keeps the same 8/16/24 right-
      //align padding for 1-3 digits, so short-HP layout is unchanged.
      lda current
      appendDragonInteger4()
      append.literal("/")
      lda maximum
      //#7: a hidden maximum HP is stored as 0 (eg the summoned Alexander) -> draw
      //"????" like JP instead of a literal 0. Current HP still renders above.
      appendDragonInteger4()
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(playerHpValue); write.bpp2()
      leave; rtl

    dragon:
      if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
        tilemap.setAddress(KO_UNIT_DRAGON_HP_POS)
      }
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(hpRange); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      lda current
      appendDragonInteger4()
      append.literal("/")
      lda maximum
      //#7: hidden maximum HP is stored as 0 (eg the summoned Alexander, which is
      //typed as a dragon-class unit here) -> draw "????" like JP, not a literal 0.
      appendDragonInteger4()
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(hpRange); inx #3; write.bpp2()
      leave; rtl
    }
  }

  namespace mp {
    variable(2, type)
    variable(2, current)
    variable(2, maximum)

    //A => type
    function setType {
      enter
      sta type
      leave; rtl
    }

    //force type to MP for enemies
    function setTypeMP {
      enter
      lda #$0080; sta type
      leave; rtl
    }

    //A => current MP
    function setCurrent {
      enter
      sta current
      leave; rtl
    }

    //A => maximum MP
    function setMaximum {
      enter
      sta maximum
      jsl render
      leave; rtl
    }

    function setCurrentUnavailable {
      enter
      lda #$ffff; sta current
      leave; rtl
    }

    function setMaximumUnavailable {
      enter
      lda #$ffff; sta maximum
      jsl render
      leave; rtl
    }

    function render {
      enter
      lda character.type; cmp.w #character.dragon; bne +; jmp dragon; +
      cmp.w #character.player; bne +
      jmp playerMpRange
    +
      cmp.w #character.enemy; bne oldMpRange
      jmp enemyMpRange

    oldMpRange:
      lda type; ldx #$0000
      cmp #$0000; bne +; lda maximum; tay; lda current; append.spRange(); +
      cmp #$0080; bne +; lda maximum; tay; lda current; append.mpRange(); +
      lda #$000b; render.small.bpp2()
      allocator.index(mpRange)
      lda #$000b; jsl write.bpp2
      leave; rtl

    playerMpRange:
      tilemap.setColorGreen()
      ldx #$0000
      lda type
      cmp #$0000; beq playerSp
      cmp #$0080; beq playerMp
      jmp oldMpRange

    playerSp:
      append.literal("SP:")
      bra playerLabel

    playerMp:
      append.literal("MP:")

    playerLabel:
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(playerMpLabel); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      lda maximum; tay; lda current
      jsl appendPaddedUnitRange3Value
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(playerMpValue); write.bpp2()
      leave; rtl

    enemyMpRange:
      tilemap.setColorGreen()
      ldx #$0000; append.literal("MP:")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(enemyMpLabel); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      lda maximum; tay; lda current
      jsl appendPaddedUnitRange3Value
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(mpRange); inx #3; write.bpp2()
      leave; rtl

    dragon:
      if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
        tilemap.setAddress(KO_UNIT_DRAGON_MP_POS)
      }
      tilemap.setColorGreen()
      ldx #$0000; append.literal("MP:")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(mpRange); write.bpp2()
      tilemap.setColorWhite()
      ldx #$0000
      lda maximum; tay; lda current
      jsl appendPaddedUnitRange3Value
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(mpRange); inx #3; write.bpp2()
      leave; rtl
    }

  }

  macro writeLabel(define name) {
    enter
    if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
      pha
      lda character.type; cmp.w #character.dragon; bne notDragon{#}
      tilemap.incrementAddress(KO_UNIT_DRAGON_RIGHT_LABEL_DELTA)
    notDragon{#}:
      pla
    }
    tilemap.setColorGreen()
    ldy.w #strings.bpp2.{name}
    allocator.index({name}Label)
    lda #$0005; write.bpp2(lists.strings.bpp2)
    leave; rtl
  }

  //A => value
  macro writeValue(define name) {
    enter
    tilemap.incrementAddress($fffe)
    if KO_UNIT_DRAGON_LOWER_JP_ALIGN {
      pha
      lda character.type
      cmp.w #character.dragon; bne checkPlayer{#}
      tilemap.incrementAddress(KO_UNIT_DRAGON_RIGHT_VALUE_DELTA)
      bra positionDone{#}
    checkPlayer{#}:
      cmp.w #character.player; bne checkEnemy{#}
      tilemap.incrementAddress($fffe)
      bra positionDone{#}
    checkEnemy{#}:
      cmp.w #character.enemy; bne positionDone{#}
      tilemap.incrementAddress($fffe)
    positionDone{#}:
      pla
    }
    tilemap.setColorWhite()
    and #$00ff; mul(3); tay
    allocator.index({name}Value)
    lda #$0003; write.bpp2(lists.stats.bpp2)
    leave; rtl
  }

  namespace attack {
    label:; writeLabel(attack)
    value:; writeValue(attack)
  }

  namespace defense {
    label:; writeLabel(defense)
    value:; writeValue(defense)
  }

  namespace speed {
    label:; writeLabel(speed)
    value:; writeValue(speed)
  }

  namespace magic {
    label:; writeLabel(magic)
    value:; writeValue(magic)
  }

  hdmaTable: {
    db $0a,$00,$00
    db $0c,$02,$00
    db $0c,$06,$00
    db $0c,$0a,$00
    db $0c,$0e,$00
    db $0c,$12,$00
    db $0c,$16,$00
    db $0c,$1a,$00
    db $0c,$1e,$00
    db $0c,$22,$00
    db $0c,$26,$00
    db $0c,$2a,$00
    db $1c,$56,$00
    db $08,$56,$00
    db $0c,$5a,$00
    db $0c,$5e,$00
    db $0c,$62,$00
    db $04,$60,$00
    db $04,$5c,$00
    db $00
  }

  macro stat(variable index, define name) {
    lda.w #$0084+index*$80+KO_UNIT_DRAGON_PROPERTY_DELTA; sta tilemap.address
    tilemap.setColorGreen()
    ldy.w #strings.bpp2.{name}
    allocator.index(propertyLabel)
    lda #$0006; write.bpp2(lists.strings.bpp2)
    tilemap.setColorWhite()
    lda table; tax
    lda.l dragons.stats.{name},x; and #$00ff
    mul(3); tay
    allocator.index(propertyValue)
    lda #$0003; write.bpp2(lists.stats.bpp2)
  }

  macro statAbbrev(variable index, define name, define label) {
    lda.w #$0084+index*$80+KO_UNIT_DRAGON_PROPERTY_DELTA; sta tilemap.address
    tilemap.setColorGreen()
    ldx #$0000; append.literal({label})
    lda #$0006; render.small.bpp2()
    lda #$0006; allocator.index(propertyLabel); write.bpp2()
    tilemap.setColorWhite()
    lda table; tax
    lda.l dragons.stats.{name},x; and #$00ff
    mul(3); tay
    allocator.index(propertyValue)
    lda #$0003; write.bpp2(lists.stats.bpp2)
  }

  macro clearStat(variable index) {
    lda.w #$0084+index*$80+KO_UNIT_DRAGON_PROPERTY_DELTA; sta tilemap.address
    tilemap.setColorWhite()
    ldx #$0000; append.literal("      ")
    lda #$0006; render.small.bpp2()
    lda #$0006; allocator.index(propertyLabel); write.bpp2()
    ldx #$0000; append.literal("   ")
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(propertyValue); write.bpp2()
  }

  //------
  //eeb05a  ldy #$0006
  //eeb05d  lda [$40],y  ;get the current dragon
  //eeb05f  ply
  //eeb060  sec
  //eeb061  sbc #$0020   ;subtract a fixed offset
  //eeb064  sta $00
  //eeb066  lda #$0020   ;length of each dragon entry
  //eeb069  jsr $2ae9    ;multiply index by 32
  //------
  function stats {
    variable(2, table)

    enter
    // Near EN layout only: replace the unit-detail HDMA table.
    // KO JP layout disabled: keep the Japanese original HDMA table active.
    if KO_LAYOUT_NEAR_TUNED && KO_UNIT_DRAGON_CUSTOM_HDMA {
      lda.w #hdmaTable >> 0; sta $004372
      lda.w #hdmaTable >> 8; sta $004373
    }
    ldy #$0006; lda [$40],y
    sub #$0020; mul(32); sta table
    stat( 0,fire)
    stat( 1,water)
    stat( 2,thunder)
    stat( 3,recovery)
    stat( 4,poison)
    statAbbrev( 5,strength,"STR")
    statAbbrev( 6,vitality,"VIT")
    statAbbrev( 7,dexterity,"DEX")
    statAbbrev( 8,intelligence,"MIND")
    stat( 9,timidity)
    stat(10,wisdom)
    if KO_UNIT_CLEAR_UNUSED_DRAGON_STATS {
      clearStat(11)
      clearStat(12)
      clearStat(13)
      clearStat(14)
    }
    leave; rtl
  }
}

codeCursor = pc()

}
