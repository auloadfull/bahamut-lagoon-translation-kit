namespace menu {

seek(codeCursor)

//4bpp player layout shared by both magic and item screens
namespace magicItem {
  enqueue pc

  seek($ee8f59); jsl name
  seek($ee8f94); jsl level
  // Near EN layout only: widened clear width for proportional HP/MP/SP range text.
  // KO JP layout disabled: keep the original Japanese clear width.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee8fbc); ldy #$000d  //clear 13 tiles for widened HP/MP/SP range text
  }
  seek($ee8fbf); jsl statusClear
  seek($ee8fef); jsl hp.setCurrent
  seek($ee900d); jsl hp.setMaximum
  seek($ee8f77); string.skip()  //"LV" text
  seek($ee8fd0); string.skip()  //"HP" text
  seek($ee8ff9); string.skip()  //"HP" separator

  // Near EN layout only: player sprite/text coordinates for widened magic/item summary.
  // KO JP layout disabled: preserve the Japanese 8x8-grid positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee674e); dw $0080    //player #1 X
    seek($ee6752); dw $0080    //player #2 X
    seek($ee6756); dw $0080    //player #3 X
    seek($ee675a); dw $0080    //player #4 X
    seek($ee675e); dw $0028    //player #1 Y
    seek($ee6762); dw $0058    //player #2 Y
    seek($ee6766); db $0088    //player #3 Y
    seek($ee676a); db $00b8    //player #4 Y
    seek($ee8f3f); lda #$0040  //name clear
    seek($ee8f4c); lda #$0040  //name
    seek($ee8f5d); lda #$004e  //"LV" clear
    seek($ee8f71); lda #$004e  //"LV" label
    seek($ee8f87); lda #$004e  //"LV" value
    seek($ee9011); lda #$0080  //status ailments
    seek($ee8fb6); lda #$00c0  //"HP" clear
    seek($ee8fca); lda #$00c0  //"HP" label
    seek($ee8fe2); lda #$00c0  //"HP" current value
    seek($ee8ff3); lda #$00c0  //"HP" separator label
    seek($ee9000); lda #$00c0  //"HP" maximum value
    seek($ee8f98); lda #$0100  //"MP" clear
    seek($ee8fa5); lda #$0100  //"MP" line

    // Near EN layout only: use the 8x10 BG2 HDMA table replacement.
    // KO JP layout disabled: keep the Japanese original BG2 HDMA table.
    seek($eec213); db hdmaTable >>  0
    seek($eec217); db hdmaTable >>  8
    seek($eec21b); db hdmaTable >> 16
  }

  dequeue pc

  allocator.bpp4()
  allocator.shared( 4,2,magicCostLabel)
  allocator.shared( 8,2,magicCostValue)
  allocator.create( 7,8,name)
  allocator.create( 4,8,level)
  allocator.create(13,8,hpRange)
  allocator.create(13,8,mpRange)

  // Near EN layout only: replacement HDMA table for the widened 8x10 summary layout.
  // KO JP layout disabled: this table is not referenced.
  if KO_LAYOUT_NEAR_TUNED {
    function hdmaTable {
      db $0d; dw $0000

      //player 1
      db $08; dw $0002
      db $02; dw $fff8
      db $08; dw $0000
      db $02; dw $ffe8
      db $08; dw $fffe
      db $02; dw $ffd8
      db $08; dw $fffc

      //player 2 + MP cost
      db $12; dw $0002
      db $02; dw $fff8
      db $08; dw $0000
      db $02; dw $ffe8
      db $08; dw $fffe
      db $02; dw $ffd8
      db $08; dw $fffc

      //player 3
      db $12; dw $0002
      db $02; dw $fff8
      db $08; dw $0000
      db $02; dw $ffe8
      db $08; dw $fffe
      db $02; dw $ffd8
      db $08; dw $fffc

      //player 4
      db $12; dw $0002
      db $02; dw $fff8
      db $08; dw $0000
      db $02; dw $ffe8
      db $08; dw $fffe
      db $02; dw $ffd8
      db $08; dw $fffc

      db $00
    }
  }

  //A => player name
  function name {
    variable(2, index)

    enter
    and #$00ff; sta index
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

  //------
  //ee8fbc  ldy #$000c   ;length in tiles
  //ee8fbf  jsl $ee4d93  ;clear status line tiles
  //------
  function statusClear {
    jsl $ee4d93; rtl
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
      // USER_KO_TUNING: Near-tuned KO layout added pixel padding before
      // HP current/maximum values. JP_BASE keeps the raw JP caller position.
      if KO_USER_KO_TUNING {
        append.alignSkip(2)
      }
      lda current
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      append.integer_4(); +
      append.literal("/")
      if KO_USER_KO_TUNING {
        append.alignSkip(2)
      }
      lda maximum
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      append.integer_4(); +
      lda #$000a; render.small.bpp4()
      lda #$000a; allocator.index(hpRange); inx #3; write.bpp4()
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
      // USER_KO_TUNING: Near-tuned KO layout added pixel padding so 2/3 digit
      // MP/SP values line up in the widened summary. JP_BASE disables it.
      if KO_USER_KO_TUNING {
        cmp #$0064; bcs currentWide
        append.alignSkip(4)
        bra currentOffsetDone
      currentWide:
        append.alignSkip(2)
      currentOffsetDone:
      }
      lda current
      cmp #$ffff; bne +; append.literal(" ---"); bra currentDone; +
      cmp #$03e8; bcc +; append.literal(" ???"); bra currentDone; +
      append.integer_4()

    currentDone:
      append.literal("/")
      if KO_USER_KO_TUNING {
        append.alignSkip(2)
      }
      lda maximum
      if KO_USER_KO_TUNING {
        cmp #$0064; bcs maximumOffsetDone
        append.alignSkip(2)
      maximumOffsetDone:
      }
      lda maximum
      cmp #$ffff; bne +; append.literal(" ---"); bra maximumDone; +
      cmp #$03e8; bcc +; append.literal(" ???"); bra maximumDone; +
      append.integer_4()

    maximumDone:
      lda #$000a; render.small.bpp4()
      lda #$000a; allocator.index(mpRange); inx #3; write.bpp4()
      leave; rtl
    }
  }
}

namespace magic {
  enqueue pc
  seek($eec0d4); jsl magicName
  seek($eec0e3); jsl magicLevel
  seek($eec1a5); string.skip()   //"MP Cost" text
  seek($eebfd1); jsl magicCost
  seek($eec061); jsl drawWindow
  seek($ee6f2f); jmp $6f5a       //disable magic list static "LV" text

  // Near EN layout only: magic list/window/cursor/cost positions.
  // KO JP layout disabled: keep the Japanese original positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($eec047); lda #$0242  //window
    seek($ee8e01); lda #$0016  //item quantity
    seek($eec19f); lda #$020e  //"MP Cost" label
    seek($eebfbe); lda #$0186  //"MP Cost" value, aligned with list name start
    seek($eebcca); lda #$0016  //X cursor (list initial)
    seek($eebcdc); adc #$003d  //Y cursor
    seek($eebf83); lda #$0016  //X cursor (list normal)
    seek($eebf95); adc #$003d  //Y cursor
    seek($eebf21); lda #$0096  //X cursor (player)
    seek($eebf1b); adc #$fff5  //Y cursor
  }
  dequeue pc

  allocator.bpp2()
  allocator.create(8,24,magicName)
  allocator.create(3,24,magicLevel)
  allocator.bpp4()
  allocator.create(4,2,magicCostLabel)
  allocator.create(8,2,magicCostValue)

  variable(2, magicNameWidth)
  variable(2, magicLevelAddress)

  //$ea => magic count
  function drawWindow {
    php; rep #$20; pha
    // Near EN layout only: adjusted magic window tilemap origin.
    // KO JP layout disabled: use the caller's original Japanese window origin.
    if KO_LAYOUT_NEAR_TUNED {
      tilemap.setAddress($02c2)
    }
    lda $ea; and #$00ff; max.w(1)  //list should never be empty
    asl; add #$0003; tay
    jsl drawWindowMagicItem
    pla; plp; rtl
  }

  //A => magic name
  function magicName {
    enter
    and #$00ff; pha
    tax; lda lists.techniques.widths,x; and #$00ff; sta magicNameWidth
    pla; mul(8); tay
    lda #$0008; allocator.index(magicName); write.bpp2(lists.techniques.bpp2)
    leave; rtl
  }

  //A => magic level
  function magicLevel {
    enter
    and #$00ff; mul(3); tay
    lda tilemap.address; sta magicLevelAddress
    lda #$0008; sub magicNameWidth; asl
    pha; lda tilemap.address; sub $01,s; sta tilemap.address; pla
    // Technique/magic list LV is the original one-digit layout; character LV
    // fields use the bpp4 two-digit variant of levelsMagic instead.
    lda #$0003; allocator.index(magicLevel); write.bpp2(lists.levelsMagic.bpp2)
    lda magicLevelAddress; add #$0006; sta tilemap.address
    leave; rtl
  }

  //A => magic cost
  function magicCost {
    enter
    tilemap.setColorWhite()
    and #$00ff; min.w(100); mul(8); tay
    lda #$0008; allocator.index(magicCostValue); write.bpp4(lists.magicCosts.bpp4)
    leave; rtl
  }
}

namespace item {
  enqueue pc
  seek($ee8e20); jsl item
  seek($ee8e0d); jsl count
  seek($ee8d83); string.hook(noItems)
  seek($ee8dc1); jsl drawWindow  //when item count >= 1
  seek($ee8d6b); jsl drawWindow  //when item count == 0

  // Near EN layout only: item list/window/cursor positions.
  // KO JP layout disabled: keep the Japanese original positions.
  if KO_LAYOUT_NEAR_TUNED {
    seek($ee8da7); lda #$0182  //window (when item count >= 1)
    seek($ee8d5f); lda #$0182  //window (when item count == 0)
    seek($ee8c63); lda #$000f  //X cursor (list)
    seek($ee8c5d); adc #$0025  //Y cursor
    seek($ee89a3); lda #$0096  //X cursor (player)
    seek($ee899d); adc #$fff5  //Y cursor
  }
  dequeue pc

  allocator.bpp2()
  allocator.create(9,20,item)
  allocator.create(3,20,count)
  allocator.create(5, 1,noItems)

  //$58 => item count (0 for no items)
  function drawWindow {
    php; rep #$20; pha
    // Near EN layout only: adjusted item window tilemap origin.
    // KO JP layout disabled: use the caller's original Japanese window origin.
    if KO_LAYOUT_NEAR_TUNED {
      tilemap.setAddress($01c2)
    }
    lda $58; and #$00ff; max.w(1)  //add one entry for no items condition
    asl; add #$0003; tay
    jsl drawWindowMagicItem
    pla; plp; rtl
  }

  //A => item
  function item {
    variable(2, counter)

    enter
    tilemap.setColorWhite()
    and #$007f; mul(9); tay
    lda #$0009; allocator.index(item); write.bpp2(lists.items.bpp2)
    leave; rtl
  }

  //A => item count
  function count {
    enter
    tilemap.setColorWhite()
    and #$00ff
    ldx #$0000
    cmp.w #100; bcc +; append.literal(" ??"); bra render; +
    append.integer_3()
  render:
    lda #$0003; render.small.bpp2()
    lda #$0003; allocator.index(count); write.bpp2()
    leave; rtl
  }

  function noItems {
    enter
    tilemap.setColorWhite()
    ldy.w #strings.bpp2.noItemsLeftAligned
    allocator.index(noItems)
    lda #$0005; write.bpp2(lists.strings.bpp2)
    leave; rtl
  }
}

codeCursor = pc()

}
