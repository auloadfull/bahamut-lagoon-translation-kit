namespace combat {

seek(codeCursor)

//$7e3b7a => item list
namespace dragons {
  enqueue pc
  seek($c12f13); jml class.hook   //write the dragon name and class together
  seek($c198b0); jsl values; rts  //write all stat labels and values
  seek($c1a2c8); jml changes      //blink stats to indicate effects of feeding item
  seek($c19784); nop #3           //disable 16 dragon-stat tiles from being copied to $d0-$df
  seek($c19ad0); nop #2           //always show corruption stat even when timidity is < 100
  dequeue pc

  namespace positions {
    constant hp           = $7e48e4
    constant mp           = $7e48f2
    constant fire         = $7e4902
    constant water        = $7e490e
    constant thunder      = $7e491a
    constant recovery     = $7e4926
    constant poison       = $7e4932
    constant strength     = $7e4942
    constant vitality     = $7e494e
    constant dexterity    = $7e495a
    constant intelligence = $7e4966
    constant timidity     = $7e4972
    constant wisdomLabel  = $7e4984
    constant wisdom       = $7e498e  //value starts at +6 ($7e4994), aligned with VIT value
    constant wisdomSeparator = $7e499a
    constant affectionLabel = $7e499c
    constant affection    = $7e49a6  //value starts at +6 ($7e49ac), aligned with MID value
    constant affectionSeparator = $7e49b2
  }

  namespace changes {
    constant hp           = $7e088b
    constant mp           = $7e088c
    constant strength     = $7e088d
    constant vitality     = $7e088e
    constant dexterity    = $7e088f
    constant intelligence = $7e0890
    constant fire         = $7e0891
    constant water        = $7e0892
    constant thunder      = $7e0893
    constant recovery     = $7e0894
    constant poison       = $7e0895
    constant corruption   = $7e0896
    constant timidity     = $7e0897
    constant wisdom       = $7e0898
    constant aggression   = $7e0899
    constant mutation     = $7e089a
    constant affection    = $7e089b
  }

  namespace tiles {
    constant hp           = $00d  //2 tiles
    constant mp           = $00b  //2 tiles
    constant fire         = $013  //1 tile
    constant water        = $014  //1 tile
    constant thunder      = $017  //1 tile
    constant recovery     = $0cb  //1 tile
    constant poison       = $015  //1 tile
    constant strength     = $16a  //2 tiles
    constant vitality     = $16e  //2 tiles
    constant dexterity    = $170  //2 tiles
    constant intelligence = $172  //2 tiles; patched to MID for KO
    constant question     = $174  //1 tile; original stats-font ? marker
    constant wisdom       = $174  //2 tiles
    constant aggression   = $176  //2 tiles
    constant affection    = $178  //2 tiles
    constant timidity     = $17a  //2 tiles
    constant corruption   = $17c  //2 tiles
    constant mutation     = $17e  //2 tiles
    constant separator    = $004  //1 tile
  }


  namespace slots {
    //Keep dragon status dynamic tiles inside the original dragon-stat range.
    //Do not use $064-$087: that range is reused by the feed item count list.
    constant hp             = $030  //4 tiles: $030-$033
    constant mp             = $034  //3 tiles: $034-$036
    constant timidity       = $052  //3 tiles: $052-$054
    constant wisdom         = $055  //3 tiles: $055-$057
    constant affection      = $058  //3 tiles: $058-$05a
    constant wisdomLabel    = $05b  //2 tiles: $05b-$05c
    constant affectionLabel = $05d  //3 tiles: $05d-$05f
  }


  namespace sources {
    constant combatFont = $e61b40
  }

  namespace class {
    //------
    //c12f13  jsr $2fb5
    //c12f16  bra $2eed
    //------
    function hook {
      enter; sep #$20
      pha; lda.b #constants.hook; sta $002180
      lda.b #constants.dragonClass; sta $002180
      pla; sta $002180
      lda.b #constants.terminal; sta $002180
      leave; jml $c12eed
    }

    //A => dragon class name
    function name {
      variable(2, identifier)

      enter
      and #$00ff; sta identifier

      //Dragon feeding status uses the Japanese fixed-column layout:
      //8-tile dragon name, one slash tile, 8-tile class, then fixed HP/MP.
      //Do not format this as one variable-width string; long English text
      //otherwise pushes HP/MP and clips the four-digit HP value.
      lda player.name.identifier
      jsl koName.renderDefaultToNameBufferBpp4
      lda player.name.identifier
      and #$00ff
      cmp #$0009; jcs staticName
    dynamicName:
      mul(8); tay
      ldx #$0088
      lda #$0008; write.bpp4(names.buffer.bpo4)
      bra writeName
    staticName:
      mul(8); tay
      ldx #$0088
      lda #$0008; write.bpp4(lists.names.bpo4)
    writeName:
      ldy #$0088
      ldx #$00c2
      lda #$0008; tilemap.write()

      ldx #$0000; txy
      append.literal("/")
      lda #$0001; render.small.bpo4()
      ldx #$0098
      lda #$0001; write.bpp4()
      ldy #$0098
      ldx #$00d2
      lda #$0001; tilemap.write()

      lda identifier
      mul(8); tay
      ldx #$0090
      lda #$0008; write.bpp4(lists.dragons.bpo4)
      ldy #$0090
      ldx #$00d4
      lda #$0008; tilemap.write()

      leave; rtl
    }
  }

  macro preloadStaticTiles(variable source, variable target, variable count) {
    ldy.w #source
    ldx.w #target
    lda.w #count; write.bpp4(sources.combatFont)
  }

  function preloadStaticLabels {
    enter
    //Cold boot/load can enter this screen before the combat font tiles used
    //by the fixed dragon labels are resident in VRAM. Refresh them explicitly.
    preloadStaticTiles(tiles.mp,       tiles.mp,       4)   //MP + HP labels
    preloadStaticTiles(tiles.strength, tiles.strength, 11)  //STR/VIT/DEX/MID/?
    leave; rtl
  }

  macro value(variable index, variable separator, variable tiles, define stat) {
    if separator  {; lda.w #tiles.separator; ora #$3800; sta.w positions.{stat}+0; }
    if tiles >= 1 {; lda.w #tiles.{stat}+0;  ora #$3800; sta.w positions.{stat}+2; }
    if tiles >= 2 {; lda.w #tiles.{stat}+1;  ora #$3800; sta.w positions.{stat}+4; }
    if index == 0 {
      //HP
      lda points; tax
      lda.l dragons.stats.{stat},x; ldx #$0000
      cmp.w #10000; bcc hp1{#}; append.literal("^^^^"); bra hp2{#}; hp1{#}:
      append.integer_4(); hp2{#}:
    }
    if index == 1 {
      //MP
      lda points; tax
      lda.l dragons.stats.{stat},x; ldx #$0000; append.alignRight()
      cmp.w #1000; bcc mp1{#}; append.literal("^^^"); bra mp2{#}; mp1{#}:
      append.integer_3(); mp2{#}:
    }
    if index == 0 {
      //HP needs four visible digits; use a dedicated non-overlapping
      //four-tile scratch slot instead of the shared 3x17 stat table.
      lda #$0004; render.small.bpo4()
      ldx #slots.hp
      lda #$0004; write.bpp4()
      txa; add #$00a0; tax
      lda #$0004; render.small.bpo4.to.bpa4(); write.bpp4()
      txa; sub #$00a0; tay
      lda #$0004; ldx.w #positions.{stat}+6&$3ff; tilemap.write()
    } else if index == 1 {
      lda #$0003; render.small.bpo4()
      ldx #slots.mp
      lda #$0003; write.bpp4()
      txa; add #$00a0; tax
      lda #$0003; render.small.bpo4.to.bpa4(); write.bpp4()
      txa; sub #$00a0; tay
      lda #$0003; ldx.w #positions.{stat}+6&$3ff; tilemap.write()
    } else {
      lda stats; tax
      lda.l dragons.stats.{stat},x; and #$00ff
      mul(3); tay
      index.to3x17(index)
      txa; add #$0001; tax  //HP uses one extra tile, so shift remaining stat slots by +1
      lda #$0003; write.bpp4(lists.stats.bpo4)
      txa; add #$00a0; tax
      lda #$0003; write.bpp4(lists.stats.bpa4)
      txa; sub #$00a0; tay
      lda #$0003; ldx.w #positions.{stat}+6&$3ff; tilemap.write()
    }
  }

  macro label(variable index, variable tiles, define label, variable target) {
    ldy.w #strings.bpo4.{label}
    ldx.w #index
    lda.w #tiles; write.bpp4(lists.strings.bpo4)
    ldy.w #index
    ldx.w #target&$3ff
    lda.w #tiles; tilemap.write()
  }

  macro valueOnly(variable index, define stat) {
    lda stats; tax
    lda.l dragons.stats.{stat},x; and #$00ff
    mul(3); tay
    ldx.w #index
    lda #$0003; write.bpp4(lists.stats.bpo4)
    txa; add #$00a0; tax
    lda #$0003; write.bpp4(lists.stats.bpa4)
    txa; sub #$00a0; tay
    lda #$0003; ldx.w #positions.{stat}+6&$3ff; tilemap.write()
  }

  //X => HP/MP index
  function values {
    constant statIndex = $0967

    variable(2, points)
    variable(2, stats)

    enter; ldb #$7e
    jsl preloadStaticLabels
    txa; sta points
    lda.w statIndex; and #$00ff
    sub #$0020; mul(32); sta stats
    value( 0,1,2,hp)
    value( 1,1,2,mp)
    value( 2,0,1,fire)
    value( 3,1,1,water)
    value( 4,1,1,thunder)
    value( 5,1,1,recovery)
    value( 6,1,1,poison)
    value( 7,0,2,strength)
    value( 8,1,2,vitality)
    value( 9,1,2,dexterity)
    value(10,1,2,intelligence)

    //Original row 3 keeps a fifth short marker/value column after MID.
    //Near moved this data into the English row-4 summary as TIM.
    lda.w #tiles.separator; ora #$3800; sta.w positions.timidity+0
    lda.w #tiles.question;  ora #$3800; sta.w positions.timidity+2
    valueOnly(slots.timidity,timidity)

    //Japanese original uses two long row-4 labels here, not Near's
    //five-column AGG/AFF/TIM/COR/MUT summary.  Render labels and values
    //independently so label width never pushes the numeric columns.
    label(slots.wisdomLabel,2,wisdom,positions.wisdomLabel)
    valueOnly(slots.wisdom,wisdom)
    lda.w #tiles.separator; ora #$3800; sta.w positions.wisdomSeparator
    label(slots.affectionLabel,3,affection,positions.affectionLabel)
    valueOnly(slots.affection,affection)
    lda.w #tiles.separator; ora #$3800; sta.w positions.affectionSeparator
    leave
    lda $3c; ora #$02; sta $3c  //request tilemap to VRAM transfer
    rtl
  }

  macro change4(define stat) {
    lda.w changes.{stat}; and #$00ff
    beq finished{#}
    cmp #$0080; bcs decrease{#}  //8-bit signed value
  increase{#}:  //white -> yellow text
    lda.w positions.{stat}+ 6; add #$00a0; sta.w positions.{stat}+ 6
    lda.w positions.{stat}+ 8; add #$00a0; sta.w positions.{stat}+ 8
    lda.w positions.{stat}+10; add #$00a0; sta.w positions.{stat}+10
    lda.w positions.{stat}+12; add #$00a0; sta.w positions.{stat}+12
    bra finished{#}
  decrease{#}:  //white -> gray text
    lda.w positions.{stat}+ 6; ora #$1c00; sta.w positions.{stat}+ 6
    lda.w positions.{stat}+ 8; ora #$1c00; sta.w positions.{stat}+ 8
    lda.w positions.{stat}+10; ora #$1c00; sta.w positions.{stat}+10
    lda.w positions.{stat}+12; ora #$1c00; sta.w positions.{stat}+12
  finished{#}:
  }

  macro change(define stat) {
    lda.w changes.{stat}; and #$00ff
    beq finished{#}
    cmp #$0080; bcs decrease{#}  //8-bit signed value
  increase{#}:  //white -> yellow text
    lda.w positions.{stat}+ 6; add #$00a0; sta.w positions.{stat}+ 6
    lda.w positions.{stat}+ 8; add #$00a0; sta.w positions.{stat}+ 8
    lda.w positions.{stat}+10; add #$00a0; sta.w positions.{stat}+10
    bra finished{#}
  decrease{#}:  //white -> gray text
    lda.w positions.{stat}+ 6; ora #$1c00; sta.w positions.{stat}+ 6
    lda.w positions.{stat}+ 8; ora #$1c00; sta.w positions.{stat}+ 8
    lda.w positions.{stat}+10; ora #$1c00; sta.w positions.{stat}+10
  finished{#}:
  }

  //------
  //c1a2c8  pha
  //c1a2c9  jsr $a2de
  //------
  function changes {
    pha
    enter; ldb #$7e
    change4(hp)
    change(mp)
    change(strength)
    change(vitality)
    change(dexterity)
    change(intelligence)
    change(fire)
    change(water)
    change(thunder)
    change(recovery)
    change(poison)
    change(timidity)
    change(wisdom)
    change(affection)
    leave
    lda $3c; ora #$02; sta $3c  //request tilemap to VRAM transfer
    jml $c1a2cc
  }

  function feed {
    enter
    ldy.w #strings.bpo4.feed
    index.to9x16(0)
    lda #$0004; write.bpp4(lists.strings.bpo4)
    txa; ora #$3800
    sta $7e4c1e; inc
    sta $7e4c20; inc
    sta $7e4c22; inc
    sta $7e4c24
    leave; rtl
  }

  function exit {
    enter
    ldy.w #strings.bpo4.exit
    index.to9x16(1)
    lda #$0004; write.bpp4(lists.strings.bpo4)
    txa; ora #$3800
    sta $7e4c9e; inc
    sta $7e4ca0; inc
    sta $7e4ca2; inc
    sta $7e4ca4
    leave; rtl
  }
}

codeCursor = pc()

}
