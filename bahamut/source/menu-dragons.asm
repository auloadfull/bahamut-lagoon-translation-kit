namespace menu {

seek(codeCursor)

namespace dragons {
  enqueue pc

  seek($eec783); jsl deployedName
  seek($eec7a8); jsl reservedName
  seek($eecb86); jsl playerName
  seek($eecbb8); string.hook(reservedDragon)
  seek($eecb2a); jsl drawWindowOverview
  seek($eec67f); jsl properties.main; plp; rts

  //cursor positions (JP original values)
  seek($eec8e2); {
    dw $14,$13  //party 1
    dw $64,$13  //party 2
    dw $b4,$13  //party 3
    dw $14,$45  //party 4
    dw $64,$45  //party 5
    dw $b4,$45  //party 6
    dw $14,$77  //reserve
  }

  //name positions (+8px = +1 tile right to match JP)
  seek($eec7c4); lda #$0146  //party 1
  seek($eec7cb); lda #$015a  //party 2
  seek($eec7d2); lda #$016e  //party 3
  seek($eec7d9); lda #$02c6  //party 4
  seek($eec7e0); lda #$02da  //party 5
  seek($eec7e7); lda #$02ee  //party 6
  seek($eec790); lda #$0446  //reserve

  //player/dragon sprite X,Y positions: not hooked - the JP original tables
  //remain in effect (player X $16/$66/$b6, dragon X $05/$0f/$19, reserve $05;
  //Near had shifted the whole block 8px left).

  //party overview window (JP original values throughout; the restored BG3VOFS
  //table below gives the original 16px-band row spacing these assume)
  seek($eecb07); lda #$0418  //window clear position    (JP original)
  seek($eecb0d); ldx #$0013  //window clear width       (JP original)
  seek($eecb10); ldy #$000f  //window clear height (JP original $10 minus one row: row 31 now belongs to the stats labels and must survive party switches)
  seek($eecb1e); lda #$0456  //window write position    (JP original: row 17, col 11)
  seek($eecb24); ldx #$0014  //window write width       (JP original)
  seek($eecb27); ldy #$000e  //window write height      (JP original)
  seek($eec608); lda #$70    //sprite X position        (JP original)
  seek($eec60d); lda #$6d    //sprite Y position        (JP original)
  seek($eecb5e); lda #$05d8  //player name list position (JP original: row 23, col 12)
  seek($eecb46); lda #$0526  //technique list position   (JP original: row 20, col 19)
  seek($eecbb2); lda #$05de  //"Reserved Dragon" position (JP original)

  //dragon stats window
  seek($eec67b); nop #4      //disable clearing stats when changing dragons

  //BG3VOFS HDMA table: not hooked - the JP original table at $eecd96 remains
  //in effect (12px text bands; VOFS stays flat below scanline 184, so the
  //stats rows render on the plain 8px tile grid).

  dequeue pc

  allocator.bpp4()
  allocator.create( 8,12,deployedName)
  allocator.create( 8, 4,reservedName)
  allocator.bpp2()
  allocator.create( 5, 2,party)
  allocator.create( 7, 8,playerName)
  allocator.create( 9,10,techniqueName)  //9 wide so the unused-slot dashes (9) fit
  allocator.create( 3,10,techniqueLevel)
  allocator.create(15, 2,reservedDragon)
  allocator.create( 8, 2,selectedDragon)
  allocator.create( 4,10,statLabels)  //10 KO 12x12 labels, 2x2 tiles each
  allocator.create( 3,20,statValues)  //10 stat values, 3 composed tiles each (double-buffered)

  //A => dragon name
  function deployedName {
    enter
    getDragonName(); jsl koName.renderDefaultToNameBufferBpp4
    mul(8); tay
    lda #$0008; allocator.index(deployedName); write.bpp4(names.buffer.bpp4)
    leave; rtl
  }

  //A => dragon name
  function reservedName {
    enter
    getDragonName(); jsl koName.renderDefaultToNameBufferBpp4
    mul(8); tay
    lda #$0008; allocator.index(reservedName); write.bpp4(names.buffer.bpp4)
    leave; rtl
  }

  //A => party#
  function party {
    enter
    mul(5); tay
    //JP places "파티N" straddling the window's top border row, starting where
    //パーティー did. Window top-left is $0456 (row 17, col 11); the label sits
    //at row 17, col 19 = $0466. Drawn after drawWindowOverview ($eecb2a
    //precedes the party dispatch at $eecb3e), so it lands on the border. Only
    //3 of the 5 asset tiles are written: "파티N" is exactly 3 glyphs, and the
    //trailing tiles (blank except 1px of shadow) would erase the border dashes.
    tilemap.setAddress($0466)
    tilemap.setColorGreen()
    lda #$0003; allocator.index(party); write.bpp2(lists.parties.bpp2)
    tilemap.setColorWhite()
    leave; rtl
  }

  //A => player name
  function playerName {
    enter
    and #$00ff
    cmp #$0009; jcs static
  dynamic:
    jsl koName.renderDefaultToNameBufferBpp2
    mul(8); tay
    lda #$0007; allocator.index(playerName); write.bpp2(names.buffer.bpp2)
    leave; rtl
  static:
    mul(8); tay
    lda #$0007; allocator.index(playerName); write.bpp2(lists.names.bpp2)
    leave; rtl
  }

  function reservedDragon {
    enter
    tilemap.setColorWhite()
    lda #$000f; ldy.w #strings.bpp2.reserveDragon
    allocator.index(reservedDragon); write.bpp2(lists.strings.bpp2)
    leave; rtl
  }

  namespace technique {
    //A => technique name
    function name {
      enter
      and #$00ff
      cmp.w #dispatcher.technique.unusedID; bne +; jmp empty; +
      tax; lda lists.techniques.widths,x; and #$00ff; sta dispatcher.technique.nameWidth
      txa; mul(8); tay
      lda #$0006; allocator.index(techniqueName); write.bpp2(lists.techniques.bpp2)
      leave; rtl
    empty:
      //JP renders the empty slot as dashes from the menu font, not the KO list.
      lda #$0006; sta dispatcher.technique.nameWidth
      tilemap.setColorWhite()
      ldx #$0000; append.literal("---------")
      lda #$0009; render.small.bpp2()
      lda #$0009; allocator.index(techniqueName); write.bpp2()
      leave; rtl
    }

    //A => technique level
    //flows immediately after the KO name (name start + name width) instead of a
    //fixed slot, so short Korean names sit flush against their level. The
    //tilemap.address is saved and restored (matching magicLevel) so the shift is
    //local to the level draw and cannot corrupt the feeding item quantities that
    //share this screen's render path.
    function level {
      enter
      and #$00ff; min.w(100); mul(3); tay  //Y => level index into lists.levels
      lda tilemap.address; sta dispatcher.technique.levelAddress
      lda #$0006; sub dispatcher.technique.nameWidth
      bpl +; lda #$0000; +  //name wider than the slot => no shift (defensive)
      asl
      pha; lda tilemap.address; sub $01,s; sta tilemap.address; pla
      //left-aligned levels variant: single-digit hugs the LV glyph ("Lv1"),
      //while the shared lists.levels (overview/unit LV) stays right-aligned.
      lda #$0003; allocator.index(techniqueLevel); write.bpp2(lists.levelsTechnique.bpp2)
      lda dispatcher.technique.levelAddress; add #$0006; sta tilemap.address
      leave; rtl
    }
  }

  namespace properties {
    //JP-original stats row (Near's bordered 15-stat window removed): ten
    //12x12 KO labels 공방속마화수뇌토회독 (번역 확인 필요; JP 攻防速魔火水雷土回毒)
    //as 2x2 tilemap cells at $0806+6i (band rows 32-33), with the 8x8 values
    //on the band below at $08c4+6i. The selected dragon's stat block pointer
    //is in dp $12 (set by the caller before the $eec67f hook); offsets +6..+15
    //are contiguous in exactly the JP display order: str,vit,dex,int,fire,
    //water,thunder,earth,recovery,poison. (Near's dragons.stats constants
    //mislabel +$0d..+$0f as recovery/poison/corruption - do not use them.)
    variable(2, cellAddress)
    variable(2, cellTile)
    variable(2, counter)
    variable(2, hundreds)
    variable(2, tens)
    variable(2, ones)

    function main {
      enter; ldb #$7e
      tilemap.setColorWhite()

      //labels and their tilemap cells only need to be written once per screen
      //entry: check the first label's top-left tilemap cell ($c400+$07c4).
      lda $cbc4; cmp #$0000; jne values

      //clear the stats rows (31-39) first: stale tiles from the previous
      //screen and layout linger beside the labels and in the overscan rows
      //below otherwise. Write $0000 like the game's own clear routine
      //($ee4d93) does - an attributed space tile is transparent and lets the
      //art layer bleed through.
      ldx #$07c0
    -;lda #$0000; sta tilemap.location,x
      inx #2; cpx #$0a00; bcc -

      lda #$07c4; sta cellAddress
      lda #$0000; sta counter
    labelLoop:
      //slot for this label (allocator.index cycles one entry per call)
      allocator.index(statLabels); txa; sta cellTile
      lda counter; asl; asl; tay          //Y <= source tile = label# * 4
      lda cellTile; tax
      lda #$0004; write.bpp2(koDragonStatLabels.data)

      //2x2 tilemap cells referencing the slot tiles
      lda cellAddress; tax
      lda cellTile; ora tilemap.attributes; sta tilemap.location,x
      inc; inx #2; sta tilemap.location,x
      lda cellAddress; add #$0040; tax
      lda cellTile; add #$0002; ora tilemap.attributes; sta tilemap.location,x
      inc; inx #2; sta tilemap.location,x

      lda cellAddress; add #$0006; sta cellAddress
      lda counter; inc; sta counter; cmp #$000a; bcs +; jmp labelLoop; +

    values:
      //the values always need to be refreshed. Clear the digit rows (33-35)
      //with $0000 first, every refresh: stale cells (e.g. restored from an
      //old save state past the one-time gate) would otherwise linger beside
      //the fields. Then compose the 4px-left shifted JP digit halves into a
      //3-tile buffer per value - tens into tiles 0-1, ones into tiles 1-2 -
      //so neighbouring 3-column fields never overlap; values 100+ fall back
      //to on-grid menu-font digits (rare but unclipped).
      ldx #$0840
    -;lda #$0000; sta tilemap.location,x
      inx #2; cpx #$0900; bcc -

      lda #$0842; sta cellAddress
      lda #$0000; sta counter
    valueLoop:
      lda counter; add #$0006; tay
      lda [$12],y; and #$00ff

      //split A (0-250) into hundreds/tens/ones by repeated subtraction
      ldx #$0000
    -;cmp.w #100; bcc +; sub.w #100; inx; bra -
    +;stx hundreds
      ldx #$0000
    -;cmp.w #10; bcc +; sub.w #10; inx; bra -
    +;stx tens
      sta ones

      lda hundreds; jne onGrid

      //clear the 3-tile compose buffer, then OR the digit halves in
      phb; pea $3232; plb; plb
      ldx #$0000; txa
    -;sta.w $6000,x; inx #2; cpx #$0030; bcc -
      lda tens; beq +
      lda tens; mul(32); ldy #$0000; jsl orHalf
      lda tens; mul(32); add #$0010; ldy #$0010; jsl orHalf
    +;lda ones; mul(32); ldy #$0010; jsl orHalf
      lda ones; mul(32); add #$0010; ldy #$0020; jsl orHalf
      plb

      allocator.index(statValues); txa; sta cellTile
      lda cellTile; tax; ldy #$0000
      lda #$0003; write.bpp2()

      lda cellAddress; tax
      lda cellTile; ora tilemap.attributes; sta tilemap.location,x
      inc; inx #2; sta tilemap.location,x
      inc; inx #2; sta tilemap.location,x
      bra next

    onGrid:
      lda cellAddress; tax
      lda hundreds; add.w #glyph.numbers; ora tilemap.attributes; sta tilemap.location,x
      inx #2
      lda tens; add.w #glyph.numbers; ora tilemap.attributes; sta tilemap.location,x
      inx #2
      lda ones; add.w #glyph.numbers; ora tilemap.attributes; sta tilemap.location,x

    next:
      lda cellAddress; add #$0006; sta cellAddress
      lda counter; inc; sta counter; cmp #$000a; bcs +; jmp valueLoop; +
      leave; rtl
    }

    //A => byte offset into the digit-half asset; Y => compose-buffer offset.
    //DB must be $32 (the render buffer bank) on entry.
    function orHalf {
      php; rep #$30; phx
      tax
      macro orWord(variable n) {
        lda.l koDragonStatDigits.data+n*2,x; ora.w $6000+n*2,y; sta.w $6000+n*2,y
      }
      orWord(0); orWord(1); orWord(2); orWord(3)
      orWord(4); orWord(5); orWord(6); orWord(7)
      plx; plp; rtl
    }
  }
}

codeCursor = pc()

}
