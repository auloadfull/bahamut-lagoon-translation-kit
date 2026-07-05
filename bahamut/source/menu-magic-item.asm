namespace menu {

seek(codeCursor)

//4bpp player layout shared by both magic and item screens
namespace magicItem {
  enqueue pc

  seek($ee8f59); jsl name
  seek($ee8f94); jsl level
  seek($ee8fbc); ldy #$000d  //clear 13 tiles for pixel-adjusted HP/MP/SP range text
  seek($ee8fbf); jsl statusClear
  seek($ee8fef); jsl hp.setCurrent
  seek($ee900d); jsl hp.setMaximum
  seek($ee8f77); string.skip()  //"LV" text
  seek($ee8fd0); string.skip()  //"HP" text
  seek($ee8ff9); string.skip()  //"HP" separator

  //positions
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
  seek($ee8f71); lda #$004e    //"LV" label
  seek($ee8f87); lda #$004e  //"LV" value
  seek($ee9011); lda #$0080  //status ailments
  seek($ee8fb6); lda #$00c0  //"HP" clear
  seek($ee8fca); lda #$00c0  //"HP" label
  seek($ee8fe2); lda #$00c0  //"HP" current value
  seek($ee8ff3); lda #$00c0  //"HP" separator label
  seek($ee9000); lda #$00c0  //"HP" maximum value
  seek($ee8f98); lda #$0100  //"MP" clear
  seek($ee8fa5); lda #$0100  //"MP" line

  //keep the original JP BG2 HDMA table for this coordinate set.

  dequeue pc

  allocator.bpp4()
  allocator.shared( 4,2,magicCostLabel)
  allocator.shared( 3,2,magicCostValue)
  allocator.create( 7,8,name)
  allocator.create( 4,8,level)
  allocator.create( 8,8,class)
  allocator.create(13,8,hpRange)
  allocator.create(13,8,mpRange)

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

    //A => current HP
    function setCurrent {
      enter
      sta current
      leave; rtl
    }

    //A => maximum HP
    function setMaximum {
      variable(2, maximum)

      enter
      sta maximum
      tilemap.setColorGreen()
      ldx #$0000; append.literal("HP:")
      lda #$0003; render.small.bpp4()
      lda #$0003; allocator.index(hpRange); write.bpp4()
      tilemap.setColorWhite()
      ldx #$0000
      lda current
      cmp.w #100; bcs +; append.alignSkip(2); +
      lda current
      cmp.w #10000; bcc +; append.literal("????"); bra ++; +
      append.integer_4(); +
      lda current
      cmp.w #1000; bcs +; append.alignSkip(2); +
      append.literal("/")
      lda maximum
      cmp.w #1000; bcs +; append.alignSkip(2); +
      lda maximum
      cmp.w #100; bcs +; append.alignSkip(2); +
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
      cmp #$ffff; bne +; append.literal(" ---"); bra currentDone; +
      cmp #$03e8; bcc +; append.literal(" ???"); bra currentDone; +
      cmp #$0064; bcs +; append.alignSkip(2); +
      lda current; append.integer_4()

    currentDone:
      lda current
      cmp #$ffff; beq +
      cmp #$03e8; bcs +
      append.alignSkip(2); +
      append.literal("/")
      lda maximum
      cmp #$ffff; bne +; append.literal(" ---"); bra maximumDone; +
      cmp #$03e8; bcc +; append.literal(" ???"); bra maximumDone; +
      cmp #$03e8; bcs +; append.alignSkip(2); +
      lda maximum; cmp #$0064; bcs +; append.alignSkip(2); +
      lda maximum; append.integer_4()

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
  seek($eec1a5); string.hook(magicCostLabel)   //"MP Cost" text
  seek($eebfd1); jsl magicCost
  seek($eec061); jsl drawWindow
  seek($ee6f2f); jmp $6f5a       //disable magic list static "LV" text

  //positions
  seek($eec047); lda #$0242  //window
  seek($ee8e01); lda #$0016  //item quantity
  seek($eec19f); lda #$0186  //"MP Cost" label
  seek($eebfbe); lda #$018e  //"MP Cost" value
  seek($eebcca); lda #$0016  //X cursor (list initial)
  seek($eebcdc); adc #$003d  //Y cursor
  seek($eebf83); lda #$0016  //X cursor (list normal)
  seek($eebf95); adc #$003d  //Y cursor
  seek($eebf21); lda #$0096  //X cursor (player)
  seek($eebf1b); adc #$fff5  //Y cursor
  dequeue pc

  allocator.bpp2()
  allocator.create(8,24,magicName)
  allocator.create(3,24,magicLevel)
  allocator.bpp4()
  allocator.create(4,2,magicCostLabel)
  allocator.create(3,2,magicCostValue)

  variable(2, magicNameWidth)
  variable(2, magicLevelAddress)

  //$ea => magic count
  function drawWindow {
    php; rep #$20; pha
    tilemap.setAddress($02c2)
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
    // KO Near-tuned: draw Lv immediately after the variable-width Korean
    // technique name, matching the JP "nameLv1" layout instead of the Near
    // English fixed LV column.
    lda tilemap.address; sta magicLevelAddress
    lda #$0008; sub magicNameWidth; asl
    pha; lda tilemap.address; sub $01,s; sta tilemap.address; pla
    lda #$0003; allocator.index(magicLevel); write.bpp2(lists.levelsMagic.bpp2)
    lda magicLevelAddress; add #$0006; sta tilemap.address
    leave; rtl
  }

  //A => magic cost
  function magicCost {
    enter
    and #$00ff; mul(3); tay
    tilemap.setColorWhite()
    lda #$0003; allocator.index(magicCostValue); write.bpp4(lists.costsMP_num.bpi4)
    leave; rtl
  }

  function magicCostLabel {
    enter
    tilemap.setColorWhite()
    ldy.w #strings.bpp4.magicCost
    lda #$0004
    ldx.w #$0030
    write.bpp4(lists.strings.bpp4)
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

  //positions
  seek($ee8da7); lda #$0182  //window (when item count >= 1)
  seek($ee8d5f); lda #$0182  //window (when item count == 0)
  seek($ee8c63); lda #$000f  //X cursor (list)
  seek($ee8c5d); adc #$0025  //Y cursor
  seek($ee89a3); lda #$0096  //X cursor (player)
  seek($ee899d); adc #$fff5  //Y cursor
  dequeue pc

  allocator.bpp2()
  allocator.create(9,20,item)
  allocator.create(3,20,count)
  allocator.create(5, 1,noItems)

  //$58 => item count (0 for no items)
  function drawWindow {
    php; rep #$20; pha
    tilemap.setAddress($01c2)
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
    cmp.w #100; bcc +; append.alignSkip(6); append.literal("??"); bra render; +
    append.alignSkip(6)
    cmp.w #10; bcs +; append.alignSkip(2); +
    append.integer_2()
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
