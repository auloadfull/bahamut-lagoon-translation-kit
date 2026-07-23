namespace menu {

seek(codeCursor)

namespace status {
  constant KO_STATUS_UNUSED_TECHNIQUE_ID = $00ff
  constant KO_STATUS_SPRITE_X_PLAYER = $60
  constant KO_STATUS_NAME_LEVEL_TILE = 7
  constant KO_STATUS_NAME_LEVEL_OFFSET = $000e
  constant KO_STATUS_RANGE_VALUE_OFFSET_TILES = 3
  constant KO_STATUS_RANGE_VALUE_WIDTH = 9
  constant KO_STATUS_EXP_VALUE_WIDTH = 7
  constant KO_STATUS_STAT_VALUE_WIDTH = 8
  constant KO_STATUS_SECOND_TECHNIQUE_ID = $000f
  constant KO_STATUS_TECH_MENU_NORMAL_DELTA = $0000
  constant KO_STATUS_TECH_MENU_KEEP_DELTA = $0000
  constant KO_STATUS_SECOND_TECH_DETAIL_DELTA = $fffe

  enqueue pc
  seek($ee9532); jsl name
  seek($ee957b); jsl playerClass
  seek($ee9617); jsl dragonClass
  seek($ee956a); jsl level.player
  seek($ee95eb); jsl level.dragon
  seek($ee99a1); jsl techniqueName
  seek($ee99ae); jsl techniqueLevel
  seek($ee9647); jsl hp.setCurrent
  seek($ee9665); jsl hp.setMaximum
  seek($ee96b3); jsl experience.value
  seek($ee96fe); jsl nextLevel.value
  seek($ee97c1); jsl attack.setStat
  seek($ee98d4); jsl attack.setBase
  seek($ee97fb); jsl defense.setStat
  seek($ee98bf); jsl defense.setBase
  seek($ee9835); jsl speed.setStat
  seek($ee98aa); jsl speed.setBase
  seek($ee986f); jsl magic.setStat
  seek($ee9895); jsl magic.setBase
  seek($ee9751); jsl weapon
  seek($ee9781); jsl armor
  seek($ee9948); jsl techniqueMenuName
  seek($ee995a); jsl techniqueMenuLevel
  seek($ee9bc0); jsl drawWindowBG3
  seek($ee9c1e); jsl techniqueItem.name
  seek($ee9c2c); jsl techniqueItem.level
  seek($ee9c3c); jsl techniqueItem.cost
  seek($ee9628); string.skip()   //"HP" text
  seek($ee9651); string.skip()   //"HP" separator
  seek($ee9687); string.hook(experience.label)
  seek($ee96d0); string.hook(nextLevel.label)
  seek($ee97a5); string.hook(attack.label)
  seek($ee97df); string.hook(defense.label)
  seek($ee9819); string.hook(speed.label)
  seek($ee9853); string.hook(magic.label)
  seek($ee98da); string.skip()  //"Attack","Defense","Speed","Magic" "( )" text
  seek($ee9734); string.skip()  //"Weapon" text (not printed for space reasons)
  seek($ee9762); string.skip()  //"Armor"  text (not printed for space reasons)
  seek($ee954d); string.skip()  //"LV" text (player)
  seek($ee95ce); string.skip()  //"LV" text (dragon)

  // Near EN layout only: status-screen text/cursor/sprite coordinates.
  // KO JP layout disabled: preserve the Japanese ROM's original 8x8-grid coordinates.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee955d); lda #$0090  //"LV" position (player)
    seek($ee95de); lda #$0100  //"LV" position (dragon)
    seek($ee95f6); lda #$0180  //"Class" position (dragon)
    seek($ee9658); lda #$0200  //"HP" position
    seek($ee969b); lda #$030a  //"Experience"# position
    seek($ee96e6); lda #$038a  //"Next Level"# position
    seek($ee98cc); lda #$004a  //"Attack"#  position (player)
    seek($ee98b7); lda #$00ca  //"Defense"# position
    seek($ee98a2); lda #$014a  //"Speed"#   position
    seek($ee988d); lda #$01ca  //"Magic"#   position
    seek($ee97b9); lda #$004a  //"Attack"#  position (dragon)
    seek($ee97f3); lda #$00ca  //"Defense"# position
    seek($ee982d); lda #$014a  //"Speed"#   position
    seek($ee9867); lda #$01ca  //"Magic"#   position
    seek($ee9744); lda #$0700  //"Weapon" position
    seek($ee9774); lda #$0780  //"Armor"  position
    seek($ee9c30); lda #$009c  //"Technique Cost" position
    seek($ee93d2); lda #$0016  //X cursor position (menu)
    seek($ee93e4); adc #$0001  //Y cursor position
    seek($ee93b4); lda #$0016  //X cursor position (list)
    seek($ee93c6); adc #$0049  //Y cursor position

    //the technique menu levels would overlap sprites in its previous position ($60)
    seek($ee6780); db KO_STATUS_SPRITE_X_PLAYER  //X player sprite position
  }
  dequeue pc

  allocator.bpp4()
  allocator.create( 8,1,name)
  allocator.create( 5,1,level)
  allocator.create( 8,1,class)
  allocator.create( 6,2,techniqueName)
  allocator.create( 3,2,techniqueLevel)
  allocator.create(12,1,hpRange)
  allocator.create(12,1,mpRange)
  allocator.create( 5,1,experienceLabel)
  allocator.create( 7,1,experienceValue)
  allocator.create( 5,1,nextLevelLabel)
  allocator.create( 7,1,nextLevelValue)
  allocator.create( 5,1,attackLabel)
  allocator.create( 8,1,attackValue)
  allocator.create( 5,1,defenseLabel)
  allocator.create( 8,1,defenseValue)
  allocator.create( 5,1,speedLabel)
  allocator.create( 8,1,speedValue)
  allocator.create( 5,1,magicLabel)
  allocator.create( 8,1,magicValue)
  allocator.create( 5,1,weaponLabel)
  allocator.create( 5,1,armorLabel)
  allocator.create( 9,1,weapon)
  allocator.create( 9,1,armor)
  allocator.bpp2()
  allocator.create( 6,5,techniqueMenuName)
  allocator.create( 3,5,techniqueMenuLevel)
  allocator.create(8,24,techniqueItemName)
  allocator.create(3,24,techniqueItemLevel)
  allocator.create(3,24,techniqueItemCost)

  //disambiguation (dragons do not have base stat values)
  namespace character {
    variable(2, type)
    constant player = 0
    constant dragon = 1
  }

  //Keep the last technique id for paired name/level hooks.
  variable(2, playerNameRowAddress)
  variable(2, techniqueNameID)
  variable(2, techniqueNameWidth)
  variable(2, techniqueNameDelta)
  variable(2, techniqueMenuNameID)
  variable(2, techniqueMenuNameWidth)
  variable(2, techniqueMenuNameDelta)

  macro appendRightInteger3() {
    cmp.w #1000; bcc valid{#}
    append.literal("???")
    bra done{#}
  valid{#}:
    append.integer_3()
  done{#}:
  }

  macro appendStatusInteger3() {
    cmp.w #1000; bcc valid{#}
    append.literal("???")
    bra done{#}
  valid{#}:
    cmp.w #100; bcs render{#}
    cmp.w #10; bcs twoDigits{#}
  oneDigit{#}:
    append.alignSkip(16)
    bra render{#}
  twoDigits{#}:
    append.alignSkip(8)
  render{#}:
    append.integer5()
  done{#}:
  }

  //4-digit sibling of appendStatusInteger3: right-align a 1-4 digit value to a
  //fixed 4-tile edge with exact 8px alignSkip padding + integer5 (never integer_4,
  //whose '_' pad glyph is narrower than a digit and left 3-digit HP ~2px short of
  //the 4-digit column). "????" only for >=10000 (eg a hidden max HP).
  macro appendStatusInteger4() {
    cmp.w #10000; bcc valid{#}
    append.literal("????")
    bra done{#}
  valid{#}:
    cmp.w #1000; bcs render{#}
    cmp.w #100; bcs skip8{#}
    cmp.w #10; bcs skip16{#}
    append.alignSkip(24)
    bra render{#}
  skip16{#}:
    append.alignSkip(16)
    bra render{#}
  skip8{#}:
    append.alignSkip(8)
  render{#}:
    append.integer5()
  done{#}:
  }

  macro appendStatusInteger7() {
    //Value is 32-bit in Y:A (high:low), right-aligned in the 7-tile field.
    //The old code ran integer5 on the low word only, so a value past five
    //digits showed just its low 16 bits (eg EXP 1016590 -> 33550). Count the
    //digits across the full 32-bit value and render with integer10.
    cpy.w #$000f; bcc c6{#}; bne j7{#}; cmp.w #$4240; bcs j7{#}   //>= 1000000 -> 7
  c6{#}:
    cpy.w #$0001; bcc c5{#}; bne j6{#}; cmp.w #$86a0; bcs j6{#}   //>= 100000 -> 6
  c5{#}:
    cpy.w #$0000; beq lo{#}; jmp fiveDigits{#}                    //65536-99999 -> 5
  lo{#}:
    cmp.w #10000; bcc n4{#}; jmp fiveDigits{#}
  n4{#}:
    cmp.w #1000; bcc n3{#}; jmp fourDigits{#}
  n3{#}:
    cmp.w #100; bcc n2{#}; jmp threeDigits{#}
  n2{#}:
    cmp.w #10; bcc oneDigit{#}; jmp twoDigits{#}
  j7{#}:
    jmp sevenDigits{#}
  j6{#}:
    jmp sixDigits{#}
  oneDigit{#}:
    append.alignSkip(48); jmp render{#}
  twoDigits{#}:
    append.alignSkip(40); jmp render{#}
  threeDigits{#}:
    append.alignSkip(32); jmp render{#}
  fourDigits{#}:
    append.alignSkip(24); jmp render{#}
  fiveDigits{#}:
    append.alignSkip(16); jmp render{#}
  sixDigits{#}:
    append.alignSkip(8); jmp render{#}
  sevenDigits{#}:
  render{#}:
    append.integer10()
  }

  macro writeCompactLevelMagicBPP2(define target) {
    lda levelValue; mul(3); tay
    lda #$0001; allocator.index({target}); write.bpp2(lists.levelsMagic.bpp2)
    lda levelValue; mul(3); add #$0001; tay
    lda #$0001; allocator.index({target}); inx #1; write.bpp2(lists.levelsMagic.bpp2)
    lda levelValue; mul(3); add #$0002; tay
    lda #$0001; allocator.index({target}); inx #2; write.bpp2(lists.levelsMagic.bpp2)
  }

  macro writeCompactLevelMagicBPP4(define target) {
    // levelsMagic bpp4 keeps a two-digit slot: single-digit levels are
    // [icon, blank, digit], two-digit are [icon, tens, ones]. The status detail
    // wants the digit hugging the icon, so reorder to [icon, digit, blank] for a
    // single digit - but NOT for two digits, or the tens/ones swap ("10" -> "01").
    lda levelValue; cmp.w #10; bcc single{#}; jmp twoDigits{#}
  single{#}:
    lda levelValue; mul(3); tay
    lda #$0001; allocator.index({target}); write.bpp4(lists.levelsMagic.bpp4)
    lda levelValue; mul(3); add #$0002; tay
    lda #$0001; allocator.index({target}); inx #1; write.bpp4(lists.levelsMagic.bpp4)
    lda levelValue; mul(3); add #$0001; tay
    lda #$0001; allocator.index({target}); inx #2; write.bpp4(lists.levelsMagic.bpp4)
    jmp done{#}
  twoDigits{#}:
    lda levelValue; mul(3); tay
    lda #$0001; allocator.index({target}); write.bpp4(lists.levelsMagic.bpp4)
    lda levelValue; mul(3); add #$0001; tay
    lda #$0001; allocator.index({target}); inx #1; write.bpp4(lists.levelsMagic.bpp4)
    lda levelValue; mul(3); add #$0002; tay
    lda #$0001; allocator.index({target}); inx #2; write.bpp4(lists.levelsMagic.bpp4)
  done{#}:
  }

  //A => player or dragon name
  function name {
    variable(2, index)

    enter
    and #$00ff; sta index
    cmp #$0009; jcs static
  dynamic:
    lda tilemap.address; sta playerNameRowAddress
    lda index
    jsl koName.renderDefaultToNameBufferBpp4
    lda index
    mul(8); tay
    lda #$0008; allocator.index(name); write.bpp4(names.buffer.bpp4)
    leave; rtl
  static:
    lda tilemap.address; sta playerNameRowAddress
    lda index
    mul(8); tay
    lda #$0008; allocator.index(name); write.bpp4(lists.names.bpp4)
    leave; rtl
  }

  namespace level {
    variable(2, value)

    //A => player level
    function player {
      enter
      and #$00ff; sta value
      lda playerNameRowAddress
      add.w #KO_STATUS_NAME_LEVEL_OFFSET
      sta tilemap.address
      tilemap.setColorGreen()
      ldx #$0000; append.literal("LV")
      lda #$0002; render.small.bpp4()
      lda #$0002; allocator.index(level); write.bpp4()
      tilemap.setColorWhite()
      lda value
      ldx #$0000; append.alignSkip(8); append.integer5()
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(level); inx #2; write.bpp4()
      leave; rtl
    }

    //A => dragon level
    function dragon {
      enter
      and #$00ff; sta value
      tilemap.setColorGreen()
      ldx #$0000; append.literal("LV")
      lda #$0002; render.small.bpp4()
      lda #$0002; allocator.index(level); write.bpp4()
      tilemap.setColorWhite()
      lda value; and #$00ff; min.w(100); mul(3); inc; tay
      lda #$0002; allocator.index(level); inx #3; write.bpp4(lists.levelsMagic.bpp4)
      leave; rtl
    }
  }

  //A => player class name
  function playerClass {
    enter
    and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp4(lists.classes.bpp4)
    lda.w #character.player; sta character.type
    leave; rtl
  }

  //A => dragon class name
  function dragonClass {
    enter
    and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp4(lists.dragons.bpp4)
    lda.w #character.dragon; sta character.type
    leave; rtl
  }

  //A => technique name
  function techniqueName {
    enter
    and #$00ff; sta techniqueNameID
    lda.w #$0000; sta techniqueNameDelta
    lda techniqueNameID
    cmp.w #KO_STATUS_SECOND_TECHNIQUE_ID; bne detailPositionDone
    lda.w #KO_STATUS_SECOND_TECH_DETAIL_DELTA; sta techniqueNameDelta
  detailPositionDone:
    lda tilemap.address; add techniqueNameDelta; sta tilemap.address
    lda techniqueNameID
    cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne normal
    jmp empty

  normal:
    lda techniqueNameID; tax
    lda lists.techniques.widths,x; and #$00ff; sta techniqueNameWidth
    lda techniqueNameID; mul(8); tay
    lda #$0006; allocator.index(techniqueName); write.bpp4(lists.techniques.bpp4)
    leave; rtl

  empty:
    lda #$0006; sta techniqueNameWidth
    tilemap.setColorWhite()
    ldx #$0000; append.literal("------")
    lda #$0006; render.small.bpp4()
    lda #$0006; allocator.index(techniqueName); write.bpp4()
    leave; rtl
  }

  //A => technique level
  function techniqueLevel {
    variable(2, levelValue)

    enter
    and #$00ff; sta levelValue
    lda techniqueNameID; cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne normal
    jmp empty

  normal:
    lda #$0006; sub techniqueNameWidth; asl
    pha; lda tilemap.address; sub $01,s; add techniqueNameDelta; sta tilemap.address; pla
    writeCompactLevelMagicBPP4(techniqueLevel)
    leave; rtl

  empty:
    lda tilemap.address; add techniqueNameDelta; sta tilemap.address
    tilemap.incrementAddress(4)
    tilemap.setColorWhite()
    ldx #$0000; append.literal("   ")
    lda #$0003; render.small.bpp4()
    lda #$0003; allocator.index(techniqueLevel); write.bpp4()
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
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(hpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      //Right-align HP with exact alignSkip padding (appendStatusInteger4) so 1-4
      //digit values share the same ones-digit column as the SP/MP rows. integer_4
      //left 3-digit HP ~2px short of the 4-digit column because its '_' pad is
      //narrower than a digit.
      lda current
      appendStatusInteger4()
      append.literal("/")
      lda maximum
      appendStatusInteger4()
      lda #KO_STATUS_RANGE_VALUE_WIDTH; render.small.bpp4()
      lda #KO_STATUS_RANGE_VALUE_WIDTH; allocator.index(hpRange); inx #KO_STATUS_RANGE_VALUE_OFFSET_TILES; write.bpp4()
      leave; rtl

    dragon:
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(hpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      lda current
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      append.integer_4(); +
      append.literal("/")
      lda maximum
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      append.integer_4(); +
      lda #$0009; render.small.bpp4()
      lda #$0009; allocator.index(hpRange); inx #3; write.bpp4()
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

    function render {
      enter
      lda character.type; cmp.w #character.dragon; bne +; jmp dragon; +
      tilemap.setColorGreen()
      ldx #$0000
      lda type
      cmp #$0000; bne +; append.literal("SP:"); bra label; +
      cmp #$0080; bne +; append.literal("MP:"); bra label; +
      leave; rtl

    label:
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(mpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      append.alignSkip(8)
      lda current
      cmp #$ffff; bne +; append.literal("---"); bra normalCurrentDone; +
      appendStatusInteger3()

    normalCurrentDone:
      append.literal("/")
      append.alignSkip(8)
      lda maximum
      cmp #$ffff; bne +; append.literal("---"); bra normalMaximumDone; +
      appendStatusInteger3()

    normalMaximumDone:
      lda #KO_STATUS_RANGE_VALUE_WIDTH; render.small.bpp4()
      lda #KO_STATUS_RANGE_VALUE_WIDTH; allocator.index(mpRange); inx #KO_STATUS_RANGE_VALUE_OFFSET_TILES; write.bpp4()
      leave; rtl

    dragon:
      tilemap.setColorGreen()
      ldx #$0000; append.literal("MP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(mpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      append.alignSkip(8)
      lda current
      cmp #$ffff; bne dragonCurrentAvailable
      append.literal("---")
      jmp dragonCurrentDone
    dragonCurrentAvailable:
      cmp #$03e8; bcc dragonCurrentValid
      append.literal("???")
      jmp dragonCurrentDone
    dragonCurrentValid:
      appendStatusInteger3()
    dragonCurrentDone:
      append.literal("/")
      append.alignSkip(8)
      lda maximum
      cmp #$ffff; bne dragonMaximumAvailable
      append.literal("---")
      jmp dragonMaximumDone
    dragonMaximumAvailable:
      cmp #$03e8; bcc dragonMaximumValid
      append.literal("???")
      jmp dragonMaximumDone
    dragonMaximumValid:
      appendStatusInteger3()
    dragonMaximumDone:
      lda #$0009; render.small.bpp4()
      lda #$0009; allocator.index(mpRange); inx #3; write.bpp4()
      leave; rtl
    }
  }

  macro writeLabel(define name) {
    enter
    tilemap.setColorGreen()
    ldy.w #strings.bpp4.{name}
    allocator.index({name}Label)
    lda #$0005; write.bpp4(lists.strings.bpp4)
    leave; rtl
  }

  namespace experience {
    function label {
      writeLabel(experience)
    }

    function value {
      enter
      lda $1e; tay; lda $1c
      tilemap.setColorWhite()
      ldx #$0000; appendStatusInteger7()
      lda #KO_STATUS_EXP_VALUE_WIDTH; render.small.bpp4()
      lda #KO_STATUS_EXP_VALUE_WIDTH; allocator.index(experienceValue); write.bpp4()
      leave; rtl
    }
  }

  namespace nextLevel {
    function label {
      writeLabel(nextLevel)
    }

    function value {
      enter
      lda $1e; tay; lda $1c
      tilemap.setColorWhite()
      ldx #$0000; appendStatusInteger7()
      lda #KO_STATUS_EXP_VALUE_WIDTH; render.small.bpp4()
      lda #KO_STATUS_EXP_VALUE_WIDTH; allocator.index(nextLevelValue); write.bpp4()
      leave; rtl
    }
  }

  macro writePlayerValue(define name) {
    ldx #$0000
    tilemap.setColorWhite()
    lda stat; appendStatusInteger3()
    append.literal("(")
    lda base; appendStatusInteger3()
    append.literal(")")
    lda #KO_STATUS_STAT_VALUE_WIDTH; render.small.bpp4()
    tilemap.incrementAddress($fffe)
    lda #KO_STATUS_STAT_VALUE_WIDTH; allocator.index({name}Value); write.bpp4()
  }

  macro writeDragonValue(define name) {
    ldx #$0000
    tilemap.incrementAddress($fffe)
    //Per-digit skip: 1 digit +4px, 2 digits +2px (as tuned), 3 digits +0. The
    //old flat +2px pushed a 3-digit value to 2..26px inside a 24px field, so
    //its last digit was clipped ("250" drew as "25").
    lda stat
    cmp.w #100; bcs render{#}
    cmp.w  #10; bcs twoDigits{#}
    append.alignSkip(4); bra render{#}
  twoDigits{#}:
    append.alignSkip(2)
  render{#}:
    lda stat; append.integer_3()
    lda #$0003; render.small.bpp4()
    allocator.index({name}Value); write.bpp4()
  }

  macro setStat(define name) {
    enter
    sta stat
    lda character.type
    cmp.w #character.dragon; beq +; leave; rtl
  +;writeDragonValue({name})
    leave; rtl
  }

  macro setBase(define name) {
    enter
    sta base
    lda character.type
    cmp.w #character.player; beq +; leave; rtl
  +;writePlayerValue({name})
    leave; rtl
  }

  namespace attack {
    variable(2, stat)
    variable(2, base)

    label:;   writeLabel(attack)
    setStat:; setStat(attack)
    setBase:; setBase(attack)
  }

  namespace defense {
    variable(2, stat)
    variable(2, base)

    label:;   writeLabel(defense)
    setStat:; setStat(defense)
    setBase:; setBase(defense)
  }

  namespace speed {
    variable(2, stat)
    variable(2, base)

    label:;   writeLabel(speed)
    setStat:; setStat(speed)
    setBase:; setBase(speed)
  }

  namespace magic {
    variable(2, stat)
    variable(2, base)

    label:;   writeLabel(magic)
    setStat:; setStat(magic)
    setBase:; setBase(magic)
  }

  //A => weapon
  function weapon {
    enter
    pha
    tilemap.setColorGreen()
    ldy.w #strings.bpp4.weapon
    allocator.index(weaponLabel)
    lda #$0005; write.bpp4(lists.strings.bpp4)
    tilemap.setColorWhite()
    pla
    and #$00ff; bne +; lda.w #128; +  //"Nothing" => "No Weapon"
    mul(9); tay
    tilemap.incrementAddress($fffe)
    lda #$0009; allocator.index(weapon); write.bpp4(lists.items.bpp4)
    leave; rtl
  }

  //A => armor
  function armor {
    enter
    pha
    tilemap.setColorGreen()
    ldy.w #strings.bpp4.armor
    allocator.index(armorLabel)
    lda #$0005; write.bpp4(lists.strings.bpp4)
    tilemap.setColorWhite()
    pla
    and #$00ff;  bne +; lda.w #129; +  //"Nothing" => "No Armor"
    mul(9); tay
    tilemap.incrementAddress($fffe)
    lda #$0009; allocator.index(armor); write.bpp4(lists.items.bpp4)
    leave; rtl
  }

  //A => technique name
  function techniqueMenuName {
    enter
    and #$00ff; sta techniqueMenuNameID
    lda.w #KO_STATUS_TECH_MENU_NORMAL_DELTA; sta techniqueMenuNameDelta
    lda techniqueMenuNameID; cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; beq inactive
    lda techniqueMenuNameID; cmp.w #KO_STATUS_SECOND_TECHNIQUE_ID; bne adjustDone
  inactive:
    lda.w #KO_STATUS_TECH_MENU_KEEP_DELTA; sta techniqueMenuNameDelta
  adjustDone:
    lda tilemap.address; add techniqueMenuNameDelta; sta tilemap.address
    lda techniqueMenuNameID
    cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne +; jmp empty; +
    lda techniqueMenuNameID; tax; lda lists.techniques.widths,x; and #$00ff; sta techniqueMenuNameWidth
    lda techniqueMenuNameID; mul(8); tay
    allocator.index(techniqueMenuName)
    lda #$0006; write.bpp2(lists.techniques.bpp2)
    leave; rtl

  empty:
    lda #$0006; sta techniqueMenuNameWidth
    tilemap.setColorWhite()
    ldx #$0000; append.literal("------")
    lda #$0006; render.small.bpp2()
    lda #$0006; allocator.index(techniqueMenuName); write.bpp2()
    leave; rtl
  }

  //A => technique level
  function techniqueMenuLevel {
    variable(2, levelValue)

    enter
    and #$00ff; sta levelValue
    lda techniqueMenuNameID; cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne +; jmp empty; +
    lda #$0006; sub techniqueMenuNameWidth; asl
    pha; lda tilemap.address; sub $01,s; add techniqueMenuNameDelta; sta tilemap.address; pla
    writeCompactLevelMagicBPP2(techniqueMenuLevel)
    leave; rtl

  empty:
    lda tilemap.address; add techniqueMenuNameDelta; sta tilemap.address
    tilemap.setColorWhite()
    ldx #$0000; append.literal("   ")
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(techniqueMenuLevel); write.bpp2()
    leave; rtl
  }

  namespace techniqueItem {
    variable(2, nameID)
    variable(2, nameWidth)
    variable(2, levelValue)
    variable(2, costValue)

    //A => name
    function name {
      enter
      and #$00ff; sta nameID
      cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne +; jmp empty; +
      tax; lda lists.techniques.widths,x; and #$00ff; sta nameWidth
      lda nameID; mul(8); tay
      allocator.index(techniqueItemName)
      lda #$0008; write.bpp2(lists.techniques.bpp2)
      leave; rtl

    empty:
      lda #$0006; sta nameWidth
      tilemap.setColorWhite()
      ldx #$0000; append.literal("------  ")
      lda #$0008; render.small.bpp2()
      lda #$0008; allocator.index(techniqueItemName); write.bpp2()
      leave; rtl
    }

    //A => level
    function level {
      enter
      and #$00ff; sta levelValue
      lda nameID; cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne +; jmp empty; +
      lda #$0008; sub nameWidth; asl
      pha; lda tilemap.address; sub $01,s; sta tilemap.address; pla
      writeCompactLevelMagicBPP2(techniqueItemLevel)
      leave; rtl

    empty:
      tilemap.setColorWhite()
      ldx #$0000; append.literal("   ")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(techniqueItemLevel); write.bpp2()
      leave; rtl
    }

    //A => cost
    function cost {
      enter
      and #$00ff; sta costValue
      lda nameID; cmp.w #KO_STATUS_UNUSED_TECHNIQUE_ID; bne +; jmp empty; +
      //#5: inherit the game's row palette ($001862) like the name/level do, so
      //the MP cost greys out with the technique name when it cannot be used.
      //Forcing white here left the cost white while the name was greyed.
      lda costValue; and #$00ff; mul(3); tay
      lda #$0003; allocator.index(techniqueItemCost); write.bpp2(lists.stats.bpp2)
      leave; rtl

    empty:
      tilemap.setColorWhite()
      ldx #$0000; append.literal("   ")
      lda #$0003; render.small.bpp2()
      lda #$0003; allocator.index(techniqueItemCost); write.bpp2()
      leave; rtl
    }
  }
}

codeCursor = pc()

}
