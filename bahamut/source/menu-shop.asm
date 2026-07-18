namespace menu {

seek(codeCursor)

namespace shop {
  enqueue pc

  //item list
  seek($eee746); jsl item.name
  seek($eee766); jsl item.cost
  seek($eee681); jsl drawWindowPaged
  seek($eee74a); lda #$0052  //item cost position (5-tile skip field; digit edge 8px left of previous build)
  seek($eee5ac); lda #$0016  //X cursor position
  seek($eee5a5); adc #$003d  //Y cursor position

  //item exchange (buy/sell quantity)
  seek($eee3b8); jsl exchange.quantity
  seek($eee3c7); jsl exchange.piro
  seek($eee3d2); string.skip()  //disable "ko" item counter
  seek($eee3b0); lda #$024a     //exchange quantity position
  seek($eee3bc); lda #$0254     //exchange piro position (digits only)
  seek($eede9c); lda #$0025     //X cursor position
  seek($eedea3); lda #$0025     //Y cursor position

  //item page#: the shared dispatcher page hook draws the JP-style indicator
  //at tilemap.address; only the total-number position ($eee6fe) is live at
  //that moment, so point it at the JP original spot.
  seek($eee6cb); string.skip()  //disable static "Page" text
  seek($eee6e5); string.skip()  //disable static "/" separator
  seek($eee6a5); lda #$044a     //"Page#" cutout position (unused; cutout disabled)
  seek($eee6fe); lda #$044a     //"Page#" indicator position (JP original)
  seek($eee6ae); nop #4         //disable border cutout; the dispatcher overwrites the cells

  //menu
  seek($eedda0); string.hook(menu.buy)
  seek($eeddaf); string.hook(menu.sell)
  seek($eeddbe); string.hook(menu.equipment)
  seek($eeddcf); string.hook(menu.information)
  seek($eee5db); adc #$001e  //X cursor position
  seek($eee5c6); adc #$0001  //Y cursor position

  //equippable
  seek($eedd7a); string.hook(equippable)

  //piro
  seek($eee40c); string.hook(piro.label)
  seek($eee449); jsl piro.amount
  seek($eee42b); lda #$03ee  //piro amount position (8-tile field, 8px pad: edge +8px vs 07-18 build)

  //holding
  seek($eee467); string.hook(holding.label)
  seek($eee4c5); jsl holding.quantity
  seek($eee4ef); jsl holding.blank
  seek($eee48e); lda #$0578  //holding quantity position
  seek($eee4dc); lda #$0578  //holding blank position

  //equipped
  seek($eee523); string.hook(equipped.label)
  seek($eee569); jsl equipped.quantity  //buying screen
  seek($eee591); jsl equipped.quantity  //selling screen
  seek($eee506); jsl equipped.blank
  seek($eee54e); lda #$06f8  //equipped quantity position
  seek($eee4f3); lda #$06f8  //equipped blank position

  dequeue pc

  allocator.bpp2()
  allocator.create( 9,16,itemName)
  allocator.create( 6,16,itemCost)
  allocator.create( 4, 2,exchangeQuantity)
  allocator.create( 8, 2,exchangePiro)
  allocator.create( 2, 1,buy)
  allocator.create( 2, 1,sell)
  allocator.create( 7, 1,equipment)
  allocator.create( 7, 1,information)
  allocator.create(12, 1,equippable)
  allocator.create( 3, 1,piroLabel)
  allocator.create( 8, 2,piroAmount)
  allocator.create(11, 1,holdingLabel)
  allocator.create( 2, 2,holdingQuantity)
  allocator.create(11, 1,equippedLabel)
  allocator.create( 2, 2,equippedQuantity)

  namespace item {
    //A => item#
    function name {
      enter
      tilemap.setColorWhite()
      and #$007f; mul(9); tay
      lda #$0009
      allocator.index(itemName); write.bpp2(lists.items.bpp2)
      leave; rtl
    }

    //A => item cost (body lives in expanded ROM; code bank $f1 is nearly full)
    function cost {
      enter
      jml costTail
    }
  }

  namespace exchange {
    //in the original game, when pressing up to choose a quantity, instead of advancing
    //by ten immediately, it would increment by one at a time, updating the quantity and
    //piro tilemap entries ten times in a row, and then update it one final time after.
    //this was fine and mostly instantaneous for just a tilemap update, but with a
    //proportional font, each increment requires a vsync, causing the player to see the
    //quantity and piro amount updating ten times instead of just once when pressing up.
    //pressing down doesn't have this issue and the game subtracts ten from the quantity
    //all at once. to work around this issue, the calling function is pulled from the stack:
    //if the caller is $eee355, representing the ten individual increments, rendering is suppressed.
    //if the caller is $eee284, representing the final draw after incrementing, rendering is permitted.

    //A => quantity: dynamic "N개" without the leading *0, white digits.
    //A must be saved before the suppression check clobbers it.
    function quantity {
      enter
      pha
      lda $0f,s; cmp #$e357; bne +; pla; leave; rtl; +
      tilemap.setColorWhite()
      ldx #$0000
      lda $01,s; and #$00ff; cmp.w #10; bcs +
      append.alignSkip(8); +
      pla; and #$00ff; append.integer5()
      append.byte($d3)  //'개' (small-font slot $60 via encoded $d3)
      jsl padTrailingSpace
      lda #$0004; render.small.bpp2()
      allocator.index(exchangeQuantity); write.bpp2()
      leave; rtl
    }

    function piro {
      constant piroLower = $00181c
      constant piroUpper = $00181e

      enter
      tilemap.setColorWhite()
      lda $0f,s; cmp #$e357; bne +; leave; rtl; +
      lda piroUpper; tay; lda piroLower
      ldx #$0000; append.alignRight(); append.integer_8()
      append.alignSkip(2)  //nudge the digits 2px left of the pad
      jsl padTrailingSpace
      lda #$0008; render.small.bpp2()
      allocator.index(exchangePiro); write.bpp2()
      leave; rtl
    }
  }

  namespace menu {
    function buy {
      enter
      ldy.w #strings.bpp2.buy
      allocator.index(buy)
      lda #$0002; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    function sell {
      enter
      ldy.w #strings.bpp2.sell
      allocator.index(sell)
      lda #$0002; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    function equipment {
      enter
      ldy.w #strings.bpp2.equipment
      allocator.index(equipment)
      lda #$0007; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    function information {
      enter
      ldy.w #strings.bpp2.information
      allocator.index(information)
      lda #$0007; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }
  }

  function equippable {
    enter
    tilemap.setColorGreen()
    ldy.w #strings.bpp2.classesAbleToEquip
    allocator.index(equippable)
    lda #$000c; write.bpp2(lists.strings.bpp2)
    leave; rtl
  }

  namespace piro {
    function label {
      enter
      tilemap.setColorGreen()
      ldy.w #strings.bpp2.piro
      allocator.index(piroLabel)
      lda #$0003; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    function amount {
      constant piroLower = $7e8016
      constant piroUpper = $7e8018

      enter
      tilemap.setColorWhite()
      lda piroUpper; and #$00ff; tay
      lda piroLower
      ldx #$0000; append.alignRight(); append.integer_8()
      jsl padTrailingSpace; jsl padTrailingSpace
      lda #$0008; render.small.bpp2()
      allocator.index(piroAmount); write.bpp2()
      leave; rtl
    }
  }

  namespace holding {
    function label {
      enter
      tilemap.setColorGreen()
      ldy.w #strings.bpp2.currentlyHolding
      allocator.index(holdingLabel)
      lda #$000b; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    //A => # of current item player holds
    function quantity {
      enter
      tilemap.setColorWhite()
      and #$00ff
      cmp #$00ff; bne +; lda.w #101; bra ++; +  //"--"
      min.w(100); +  //100+ => "??"
      mul(2); tay
      allocator.index(holdingQuantity)
      lda #$0002; write.bpp2(lists.quantities.bpp2)
      leave; rtl
    }

    function blank {
      enter
      lda #$ffff; jsl quantity
      leave; rtl
    }
  }

  namespace equipped {
    function label {
      enter
      tilemap.setColorGreen()
      ldy.w #strings.bpp2.currentlyEquipped
      allocator.index(equippedLabel)
      lda #$000b; write.bpp2(lists.strings.bpp2)
      leave; rtl
    }

    //A => # of current item player has equipped
    function quantity {
      enter
      tilemap.setColorWhite()
      and #$00ff
      cmp #$00ff; bne +; lda.w #101; bra ++; +  //"--"
      min.w(100); +  //100+ => "??"
      mul(2); tay
      allocator.index(equippedQuantity)
      lda #$0002; write.bpp2(lists.quantities.bpp2)
      leave; rtl
    }

    function blank {
      enter
      lda #$ffff; jsl quantity
      leave; rtl
    }
  }
}

codeCursor = pc()

seek(textCursor)

namespace shop {
  //Append one trailing 4px space to render.text, keeping the append.*
  //convention of leaving X on the terminal byte. Call sites stack calls to
  //tune the right-aligned digit edge in 4px steps while keeping the final
  //render tile blank. Lives in expanded ROM; code bank $f1 is nearly full.
  function padTrailingSpace {
    php; sep #$20
    lda.b #'_'; sta.l render.text,x; inx
    lda.b #$ff; sta.l render.text,x
    rep #$20; plp; rtl
  }

  //Shop price: white, right-aligned via fixed per-digit-count skips so every
  //row shares one right edge (small-font digits are 8px and digit-pair
  //kerning is zero). The rendered digits end at 40px, on the tile boundary,
  //so a 4px trailing pad extends the field to 44px and forces the boundary
  //tile loss into a blank pad tile; six tiles are transferred with the last
  //tile blank so the window border column is never touched.
  //Entered via jml from item.cost; leave unwinds that function's enter.
  function costTail {
    constant cost = $00181c

    tilemap.setColorWhite()
    ldx #$0000
    lda cost
    cmp.w #1000; bcs skip4
    cmp.w  #100; bcs skip3
    cmp.w   #10; bcs skip2
    append.alignSkip(32); bra skipDone
  skip2:
    append.alignSkip(24); bra skipDone
  skip3:
    append.alignSkip(16); bra skipDone
  skip4:
    append.alignSkip(8)
  skipDone:
    lda cost; append.integer5()
    jsl padTrailingSpace
    lda #$0006; render.small.bpp2()
    allocator.index(itemCost); write.bpp2()
    //the blank pad tile covers the window border column; put the border back
    phb; php; rep #$30
    ldb #$7e
    lda.w tilemap.address; sub #$0002; tax
    lda.w #$68f8; sta.w tilemap.location,x
    plp; plb
    leave; rtl
  }
}

textCursor = pc()

}
