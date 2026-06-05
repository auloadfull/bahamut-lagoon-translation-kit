namespace menu {

seek(codeCursor)

namespace equipment {
  enqueue pc
  seek($eeb6e7); jsl name
  seek($eeb721); jsl level
  seek($eeb73e); jsl class
  seek($eeb786); jsl hp.setCurrent
  seek($eeb7a3); jsl hp.setMaximum
  seek($eeb7cd); string.hook(attack.label)
  seek($eeb800); string.hook(defense.label)
  seek($eeb833); string.hook(speed.label)
  seek($eeb866); string.hook(magic.label)
  seek($eeb7ef); jsl attack.setFromValue
  seek($eeb822); jsl defense.setFromValue
  seek($eeb855); jsl speed.setFromValue
  seek($eeb888); jsl magic.setFromValue
  seek($eeb523); jsl shared.setToValue
  seek($eeb8a9); jsl shared.setToUnchanged
  seek($eeb8ea); jsl equippedWeapon
  seek($eeb926); jsl equippedArmor
  seek($eeb967); jsl drawWindowEquipment
  seek($eeb9a5); jsl itemName
  seek($eeb995); jsl itemCount
  seek($eeb705); string.skip()  //"LV" text
  seek($eeb768); string.skip()  //"HP" text
  seek($eeb790); string.skip()  //"HP" separator
  seek($eeb4cc); nop #12        //disable static "---" text
  seek($eeb515); nop #12        //disable static "   " text
  seek($eeb8ce); string.hook(weaponLabel)
  seek($eeb908); string.hook(armorLabel)

  // Near EN layout only: equipment summary/list coordinates and widened item list.
  // KO JP layout disabled: keep original Japanese 8x8-grid positions, cursors, and window width.
  if KO_LAYOUT_NEAR_TUNED {
    seek($eeb715); lda #$0252     //"LV" position
    seek($eeb797); lda #$0342     //"HP" position
    seek($eeb8de); lda #$074c     //weapon name position
    seek($eeb91a); lda #$07cc     //armor name position
    seek($eeb95d); ldx #$000f     //item list window width (increase by 1)
    seek($eeb946); ldx #$000f     //item list window clear width
    seek($eeb987); lda #$0016     //item quantity position
    seek($eeb2e2); lda #$0086     //weapon/armor X cursor position (initial)
    seek($eeb2db); adc #$009d     //weapon/armor Y cursor position (initial)
    seek($eeb3a2); lda #$0086     //weapon/armor X cursor position (active)
    seek($eeb39b); adc #$009d     //weapon/armor Y cursor position (active)
  }
  dequeue pc

  allocator.bpp4()
  allocator.create( 7, 1,name)
  allocator.create( 4, 1,level)
  allocator.create( 8, 1,class)
  allocator.create(12, 1,hpRange)
  allocator.create(12, 1,mpRange)
  allocator.create( 9, 2,equippedWeapon)
  allocator.create( 9, 2,equippedArmor)
  allocator.create( 5, 1,weaponLabel)
  allocator.create( 5, 1,armorLabel)
  allocator.create( 5, 1,attackLabel)
  allocator.create( 5, 1,defenseLabel)
  allocator.create( 5, 1,speedLabel)
  allocator.create( 5, 1,magicLabel)
  allocator.create( 8, 2,attackChange)
  allocator.create( 8, 2,defenseChange)
  allocator.create( 8, 2,speedChange)
  allocator.create( 8, 2,magicChange)
  allocator.bpp2()
  allocator.create( 9,24,itemName)
  allocator.create( 3,24,itemCount)

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

  macro appendMagicGridInteger4() {
    cmp #$ffff; bne valid{#}
    append.literal(" ---"); jmp done{#}
  valid{#}:
    cmp #$03e8; bcc render{#}
    append.literal(" ???"); jmp done{#}
  render{#}:
    appendGridInteger4()
  done{#}:
  }

  //A => player name
  function name {
    enter
    and #$00ff
    cmp #$0009; jcs static
  dynamic:
    mul(8); tay
    lda #$0007; allocator.index(name); write.bpp4(names.buffer.bpp4)
    leave; rtl
  static:
    mul(8); tay
    lda #$0007; allocator.index(name); write.bpp4(lists.names.bpp4)
    leave; rtl
  }

  //A => level
  function level {
    variable(2, value)

    enter
    and #$00ff; sta value
    tilemap.setColorGreen()
    ldx #$0000; append.literal("LV")
    lda #$0002; render.small.bpp4()
    lda #$0002; allocator.index(level); write.bpp4()
    tilemap.setColorWhite()
    lda value; and #$00ff; min.w(100); mul(3); inc; tay
    lda #$0002; allocator.index(level); inx #2; write.bpp4(lists.levelsMagic.bpp4)
    leave; rtl
  }

  //A => class
  function class {
    enter
    and #$00ff; mul(8); tay
    lda #$0008; allocator.index(class); write.bpp4(lists.classes.bpp4)
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
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(hpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      lda current
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      appendGridInteger4(); +
      append.literal("/")
      lda maximum
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      appendGridInteger4(); +
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
      lda current
      appendMagicGridInteger4()

    currentDone:
      append.literal("/")
      lda maximum
      appendMagicGridInteger4()

    maximumDone:
      lda #$0009; render.small.bpp4()
      lda #$0009; allocator.index(mpRange); inx #3; write.bpp4()
      leave; rtl
    }
  }

  namespace shared {
    function setToValue {
      enter; ldb #$00; ldx.w tilemap.address
      cpx #$14fa; bne +; jsl  attack.setToValue; +
      cpx #$157a; bne +; jsl defense.setToValue; +
      cpx #$15fa; bne +; jsl   speed.setToValue; +
      cpx #$167a; bne +; jsl   magic.setToValue; +
      leave; rtl
    }

    function setToUnchanged {
      enter; ldb #$00; ldx.w tilemap.address
      cpx #$14f6; bne +; jsl  attack.setToUnchanged; +
      cpx #$1576; bne +; jsl defense.setToUnchanged; +
      cpx #$15f6; bne +; jsl   speed.setToUnchanged; +
      cpx #$1676; bne +; jsl   magic.setToUnchanged; +
      leave; rtl
    }
  }

  macro label(define name) {
    enter
    tilemap.setColorGreen()
    ldy.w #strings.bpp4.{name}
    allocator.index({name}Label)
    lda #$0005; write.bpp4(lists.strings.bpp4)
    tilemap.setColorWhite()
    leave; rtl
  }

  function weaponLabel {
    label(weapon)
  }

  function armorLabel {
    label(armor)
  }

  //The original game used palette swaps plus arrows for stat changes.
  //The Korean equipment screen keeps the same two 3-tile stat columns:
  // - left column: current value, rendered dynamically in white
  // - right column: "---" when no item is selected, or right-aligned target value
  //Increases and decreases use the existing menu stat palettes; unchanged
  //target values use the normal white stat tiles.  No up/down arrows are written.
  macro value(define name, variable mapAddress, variable normalOffset) {
    enter

    tilemap.setColorPalette(0)

    if KO_USER_KO_TUNING == 0 {
      // RENDER_HOOK JP_BASE path: keep dynamic Korean stat rendering, but do
      // not apply the user's Near-tuned two-column/right-aligned stat geometry.
      lda changed; jeq normalBase{#}
      lda from; cmp to; jeq normalBase{#}
      jmp changeBase{#}

    normalBase{#}:
      ldx #$0000
      lda from; append.integer_3()
      lda #$0003; render.small.bpp4()
      allocator.index({name}Change); write.bpp4()
      leave; rtl

    changeBase{#}:
      ldx #$0000
      lda from; append.integer_3()
      append.literal("/")
      lda to; append.integer_3()
      lda #$0007; render.small.bpp4()
      allocator.index({name}Change); write.bpp4()
      leave; rtl
    }

    if KO_USER_KO_TUNING {
    // Near EN layout only: force the adjusted two-column stat tilemap address.
    // KO JP layout disabled: preserve the caller's original Japanese tilemap address.
      tilemap.setAddress(mapAddress)

    //determine whether to write "### ---" (normal) or "### ###" (change)
    lda changed; jeq normal{#}
    jmp change{#}

  normal{#}:
    ldx #$0000
    append.alignSkip(normalOffset)
    lda from; appendGridInteger3()
    lda #$0005; render.small.bpp4()
    allocator.index({name}Change); phx
    lda #$0005; write.bpp4()
    pla; add #$0005; pha
    // Near EN layout only: force the adjusted target-value column.
    // KO JP layout disabled: continue from the caller/original tilemap flow.
    if KO_LAYOUT_NEAR_TUNED {
      tilemap.setAddress(mapAddress+$000a)
    }
    ldx #$0000; append.alignRight(); append.literal("---")
    lda #$0003; render.small.bpp4()
    pla; tax
    lda #$0003; write.bpp4()
    leave; rtl

  change{#}:
    ldx #$0000
    append.alignSkip(normalOffset)
    lda from; appendGridInteger3()
    lda #$0005; render.small.bpp4()
    allocator.index({name}Change); phx
    lda #$0005; write.bpp4()
    plx
    // Near EN layout only: force the adjusted target-value column.
    // KO JP layout disabled: continue from the caller/original tilemap flow.
    if KO_LAYOUT_NEAR_TUNED {
      tilemap.setAddress(mapAddress+$000a)
    }
    txa; add #$0005; tax
    lda from; cmp to; beq equal{#}; bcc increase{#}
    jmp decrease{#}

  //write unchanged target value in white text
  equal{#}:
    lda to; mul(3); tay
    lda #$0003; write.bpp4(lists.stats.bpp4)
    leave; rtl

  //write increased target value with the existing increase palette
  increase{#}:
    lda to; mul(3); tay
    lda #$0003; write.bpp4(lists.stats.bpi4)
    leave; rtl

  //write decreased target value in gray text
  decrease{#}:
    lda to; mul(3); tay
    lda #$0003; write.bpp4(lists.stats.bpd4)
    leave; rtl
    }
  }

  namespace attack {
    variable(2, from)
    variable(2, to)
    variable(2, changed)

    label:;          label(attack)
    value:;          value(attack,$14ec,8)
    setFromValue:;   enter; sta from; leave; rtl
    setToValue:;     enter; sta to; lda #$0001; sta changed; jsl value; leave; rtl
    setToUnchanged:; enter; lda #$0000; sta changed; jsl value; leave; rtl
  }

  namespace defense {
    variable(2, from)
    variable(2, to)
    variable(2, changed)

    label:;          label(defense)
    value:;          value(defense,$156c,8)
    setFromValue:;   enter; sta from; leave; rtl
    setToValue:;     enter; sta to; lda #$0001; sta changed; jsl value; leave; rtl
    setToUnchanged:; enter; lda #$0000; sta changed; jsl value; leave; rtl
  }

  namespace speed {
    variable(2, from)
    variable(2, to)
    variable(2, changed)

    label:;          label(speed)
    value:;          value(speed,$15ec,8)
    setFromValue:;   enter; sta from; leave; rtl
    setToValue:;     enter; sta to; lda #$0001; sta changed; jsl value; leave; rtl
    setToUnchanged:; enter; lda #$0000; sta changed; jsl value; leave; rtl
  }

  namespace magic {
    variable(2, from)
    variable(2, to)
    variable(2, changed)

    label:;          label(magic)
    value:;          value(magic,$166c,8)
    setFromValue:;   enter; sta from; leave; rtl
    setToValue:;     enter; sta to; lda #$0001; sta changed; jsl value; leave; rtl
    setToUnchanged:; enter; lda #$0000; sta changed; jsl value; leave; rtl
  }

  //A => currently equipped weapon
  function equippedWeapon {
    enter
    and #$00ff
    tilemap.setColorWhite()
    mul(9); tay
    lda #$0009; allocator.index(equippedWeapon); write.bpp4(lists.items.bpp4)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => currently equipped armor
  function equippedArmor {
    enter
    and #$00ff
    tilemap.setColorWhite()
    mul(9); tay
    lda #$0009; allocator.index(equippedArmor); write.bpp4(lists.items.bpp4)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => list item name
  function itemName {
    enter
    and #$007f
    tilemap.setColorWhite()
    mul(9); tay
    lda #$0009; allocator.index(itemName); write.bpp2(lists.items.bpp2)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => list item count
  function itemCount {
    enter
    tilemap.setColorWhite()
    and #$00ff
    ldx #$0000
    cmp.w #100; bcc +; append.literal(" ??"); bra render; +
    append.integer_3()
  render:
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(itemCount); write.bpp2()
    leave; rtl
  }
}

codeCursor = pc()

}
