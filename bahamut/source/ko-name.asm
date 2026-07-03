// Korean dynamic-name experiments live here, isolated from names.render/load.
//
// This file is display-time only:
// - do not hook names.load or names.render here
// - do not call base56.decode, append.name, render.small, or character.decode
// - write names.buffer only from explicit display-time tests
// - only replace a name when its saved base56 bytes still match the original default

namespace koName {

seek(codeCursor)

constant ENABLE = 0

// Temporary default-name tables, rendered as 8 tiles per name.
// Source: bahamut/ko/fonts/Galmuri7_8x8.png via list_prerenderer.
// bpp2: bits_per_pixel=2, palette=[0, 1, 3, 3]
defaultNameBpp20:; // 0: 뷰
  db $44,$00,$7e,$02,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$57,$14,$14
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp21:; // 1: 요요
  db $38,$00,$5c,$18,$66,$22,$3a,$02,$3c,$14,$fe,$00,$7f,$7f,$00,$00
  db $38,$00,$5c,$18,$66,$22,$3a,$02,$3c,$14,$fe,$00,$7f,$7f,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp22:; // 2: 살라맨더
  db $24,$00,$56,$00,$af,$23,$7e,$02,$3e,$22,$6e,$0e,$7c,$00,$3e,$3e
  db $f4,$00,$7e,$6a,$fe,$0a,$fe,$78,$c7,$43,$f6,$02,$7e,$7a,$02,$02
  db $ea,$00,$ff,$55,$ff,$51,$ff,$15,$7f,$75,$45,$05,$7e,$00,$3f,$3f
  db $f4,$00,$fe,$7a,$de,$42,$ce,$4a,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp23:; // 3: 아이스드래곤
  db $64,$00,$b6,$22,$de,$4a,$de,$48,$df,$4b,$6e,$0a,$36,$32,$02,$02
  db $64,$00,$b6,$22,$de,$4a,$de,$4a,$de,$4a,$6e,$0a,$36,$32,$02,$02
  db $10,$00,$18,$08,$28,$00,$54,$10,$22,$22,$fe,$00,$7f,$7f,$00,$00
  db $7c,$00,$7e,$3e,$60,$20,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $ea,$00,$7f,$55,$ff,$15,$ff,$71,$cf,$45,$ef,$05,$7f,$75,$05,$05
  db $7c,$00,$3e,$3a,$16,$02,$fe,$00,$7f,$7f,$40,$00,$7c,$00,$3e,$3e
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp24:; // 4: 썬더호크
  db $52,$00,$7f,$29,$ab,$01,$ff,$55,$57,$55,$41,$01,$7e,$00,$3f,$3f
  db $f4,$00,$fe,$7a,$de,$42,$ce,$4a,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $10,$00,$fe,$00,$7f,$3b,$3a,$02,$1c,$0c,$fe,$00,$7f,$7f,$00,$00
  db $7c,$00,$3e,$3a,$7e,$02,$3e,$3a,$02,$02,$fe,$00,$7f,$7f,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp25:; // 5: 몰텐
  db $7c,$00,$7e,$3a,$32,$22,$fe,$00,$7f,$63,$6e,$0e,$7c,$00,$3e,$3e
  db $ea,$00,$ff,$25,$ef,$65,$ef,$05,$7f,$75,$45,$05,$7e,$00,$3f,$3f
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp26:; // 6: 트윈헤드
  db $7c,$00,$7e,$06,$7c,$3c,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $64,$00,$b6,$22,$6e,$0a,$fe,$02,$7e,$5a,$52,$12,$7c,$00,$3e,$3e
  db $4a,$00,$ef,$05,$7f,$35,$bf,$05,$ff,$55,$5f,$15,$2f,$25,$05,$05
  db $7c,$00,$7e,$3e,$60,$20,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp27:; // 7: 무니무니
  db $7c,$00,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$6f,$18,$08,$08,$08
  db $84,$00,$c6,$42,$c6,$42,$c6,$42,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $7c,$00,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$6f,$18,$08,$08,$08
  db $84,$00,$c6,$42,$c6,$42,$c6,$42,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

defaultNameBpp28:; // 8: 파피
  db $f4,$00,$7e,$1a,$76,$12,$76,$10,$77,$13,$f6,$02,$7e,$7a,$02,$02
  db $f4,$00,$7e,$1a,$76,$12,$76,$12,$76,$12,$f6,$02,$7e,$7a,$02,$02
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

// bpo4: bits_per_pixel=4, palette=[4, 1, 7, 3]
defaultNameBpo40:; // 0: 뷰
  db $44,$00,$7e,$02,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$57,$14,$14
  db $bb,$00,$83,$00,$bb,$00,$83,$00,$ff,$00,$01,$00,$d7,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo41:; // 1: 요요
  db $38,$00,$5c,$18,$66,$22,$3a,$02,$3c,$14,$fe,$00,$7f,$7f,$00,$00
  db $c7,$00,$bb,$00,$bb,$00,$c7,$00,$d7,$00,$01,$00,$ff,$00,$ff,$00
  db $38,$00,$5c,$18,$66,$22,$3a,$02,$3c,$14,$fe,$00,$7f,$7f,$00,$00
  db $c7,$00,$bb,$00,$bb,$00,$c7,$00,$d7,$00,$01,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo42:; // 2: 살라맨더
  db $24,$00,$56,$00,$af,$23,$7e,$02,$3e,$22,$6e,$0e,$7c,$00,$3e,$3e
  db $db,$00,$a9,$00,$73,$00,$83,$00,$e3,$00,$9f,$00,$83,$00,$ff,$00
  db $f4,$00,$7e,$6a,$fe,$0a,$fe,$78,$c7,$43,$f6,$02,$7e,$7a,$02,$02
  db $0b,$00,$eb,$00,$0b,$00,$79,$00,$7b,$00,$0b,$00,$fb,$00,$ff,$00
  db $ea,$00,$ff,$55,$ff,$51,$ff,$15,$7f,$75,$45,$05,$7e,$00,$3f,$3f
  db $15,$00,$55,$00,$51,$00,$15,$00,$f5,$00,$bf,$00,$81,$00,$ff,$00
  db $f4,$00,$fe,$7a,$de,$42,$ce,$4a,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $0b,$00,$7b,$00,$63,$00,$7b,$00,$7b,$00,$0b,$00,$fb,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo43:; // 3: 아이스드래곤
  db $64,$00,$b6,$22,$de,$4a,$de,$48,$df,$4b,$6e,$0a,$36,$32,$02,$02
  db $9b,$00,$6b,$00,$6b,$00,$69,$00,$6b,$00,$9b,$00,$fb,$00,$ff,$00
  db $64,$00,$b6,$22,$de,$4a,$de,$4a,$de,$4a,$6e,$0a,$36,$32,$02,$02
  db $9b,$00,$6b,$00,$6b,$00,$6b,$00,$6b,$00,$9b,$00,$fb,$00,$ff,$00
  db $10,$00,$18,$08,$28,$00,$54,$10,$22,$22,$fe,$00,$7f,$7f,$00,$00
  db $ef,$00,$ef,$00,$d7,$00,$bb,$00,$ff,$00,$01,$00,$ff,$00,$ff,$00
  db $7c,$00,$7e,$3e,$60,$20,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $83,$00,$bf,$00,$bf,$00,$83,$00,$ff,$00,$01,$00,$ff,$00,$ff,$00
  db $ea,$00,$7f,$55,$ff,$15,$ff,$71,$cf,$45,$ef,$05,$7f,$75,$05,$05
  db $15,$00,$d5,$00,$15,$00,$71,$00,$75,$00,$15,$00,$f5,$00,$ff,$00
  db $7c,$00,$3e,$3a,$16,$02,$fe,$00,$7f,$7f,$40,$00,$7c,$00,$3e,$3e
  db $83,$00,$fb,$00,$eb,$00,$01,$00,$ff,$00,$bf,$00,$83,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo44:; // 4: 썬더호크
  db $52,$00,$7f,$29,$ab,$01,$ff,$55,$57,$55,$41,$01,$7e,$00,$3f,$3f
  db $ad,$00,$a9,$00,$55,$00,$55,$00,$fd,$00,$bf,$00,$81,$00,$ff,$00
  db $f4,$00,$fe,$7a,$de,$42,$ce,$4a,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $0b,$00,$7b,$00,$63,$00,$7b,$00,$7b,$00,$0b,$00,$fb,$00,$ff,$00
  db $10,$00,$fe,$00,$7f,$3b,$3a,$02,$1c,$0c,$fe,$00,$7f,$7f,$00,$00
  db $ef,$00,$01,$00,$bb,$00,$c7,$00,$ef,$00,$01,$00,$ff,$00,$ff,$00
  db $7c,$00,$3e,$3a,$7e,$02,$3e,$3a,$02,$02,$fe,$00,$7f,$7f,$00,$00
  db $83,$00,$fb,$00,$83,$00,$fb,$00,$ff,$00,$01,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo45:; // 5: 몰텐
  db $7c,$00,$7e,$3a,$32,$22,$fe,$00,$7f,$63,$6e,$0e,$7c,$00,$3e,$3e
  db $83,$00,$bb,$00,$ef,$00,$01,$00,$e3,$00,$9f,$00,$83,$00,$ff,$00
  db $ea,$00,$ff,$25,$ef,$65,$ef,$05,$7f,$75,$45,$05,$7e,$00,$3f,$3f
  db $15,$00,$25,$00,$75,$00,$15,$00,$f5,$00,$bf,$00,$81,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo46:; // 6: 트윈헤드
  db $7c,$00,$7e,$06,$7c,$3c,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $83,$00,$87,$00,$bf,$00,$83,$00,$ff,$00,$01,$00,$ff,$00,$ff,$00
  db $64,$00,$b6,$22,$6e,$0a,$fe,$02,$7e,$5a,$52,$12,$7c,$00,$3e,$3e
  db $9b,$00,$6b,$00,$9b,$00,$03,$00,$db,$00,$bf,$00,$83,$00,$ff,$00
  db $4a,$00,$ef,$05,$7f,$35,$bf,$05,$ff,$55,$5f,$15,$2f,$25,$05,$05
  db $b5,$00,$15,$00,$b5,$00,$45,$00,$55,$00,$b5,$00,$f5,$00,$ff,$00
  db $7c,$00,$7e,$3e,$60,$20,$7c,$00,$3e,$3e,$fe,$00,$7f,$7f,$00,$00
  db $83,$00,$bf,$00,$bf,$00,$83,$00,$ff,$00,$01,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo47:; // 7: 무니무니
  db $7c,$00,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$6f,$18,$08,$08,$08
  db $83,$00,$bb,$00,$83,$00,$ff,$00,$01,$00,$ef,$00,$ef,$00,$ff,$00
  db $84,$00,$c6,$42,$c6,$42,$c6,$42,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $7b,$00,$7b,$00,$7b,$00,$7b,$00,$7b,$00,$0b,$00,$fb,$00,$ff,$00
  db $7c,$00,$7e,$3a,$7e,$02,$3e,$3e,$fe,$00,$7f,$6f,$18,$08,$08,$08
  db $83,$00,$bb,$00,$83,$00,$ff,$00,$01,$00,$ef,$00,$ef,$00,$ff,$00
  db $84,$00,$c6,$42,$c6,$42,$c6,$42,$c6,$42,$f6,$02,$7e,$7a,$02,$02
  db $7b,$00,$7b,$00,$7b,$00,$7b,$00,$7b,$00,$0b,$00,$fb,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpo48:; // 8: 파피
  db $f4,$00,$7e,$1a,$76,$12,$76,$10,$77,$13,$f6,$02,$7e,$7a,$02,$02
  db $0b,$00,$9b,$00,$9b,$00,$99,$00,$9b,$00,$0b,$00,$fb,$00,$ff,$00
  db $f4,$00,$7e,$1a,$76,$12,$76,$12,$76,$12,$f6,$02,$7e,$7a,$02,$02
  db $0b,$00,$9b,$00,$9b,$00,$9b,$00,$9b,$00,$0b,$00,$fb,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

// bpa4: bits_per_pixel=4, palette=[4, 5, 6, 3]
defaultNameBpa40:; // 0: 뷰
  db $44,$00,$7c,$02,$44,$3a,$7c,$02,$00,$3e,$fe,$00,$28,$57,$00,$14
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa41:; // 1: 요요
  db $38,$00,$44,$18,$44,$22,$38,$02,$28,$14,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $38,$00,$44,$18,$44,$22,$38,$02,$28,$14,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa42:; // 2: 살라맨더
  db $24,$00,$56,$00,$8c,$23,$7c,$02,$1c,$22,$60,$0e,$7c,$00,$00,$3e
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $f4,$00,$14,$6a,$f4,$0a,$86,$78,$84,$43,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $ea,$00,$aa,$55,$ae,$51,$ea,$15,$0a,$75,$40,$05,$7e,$00,$00,$3f
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $f4,$00,$84,$7a,$9c,$42,$84,$4a,$84,$42,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa43:; // 3: 아이스드래곤
  db $64,$00,$94,$22,$94,$4a,$96,$48,$94,$4b,$64,$0a,$04,$32,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $64,$00,$94,$22,$94,$4a,$94,$4a,$94,$4a,$64,$0a,$04,$32,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $10,$00,$10,$08,$28,$00,$44,$10,$00,$22,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $7c,$00,$40,$3e,$40,$20,$7c,$00,$00,$3e,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $ea,$00,$2a,$55,$ea,$15,$8e,$71,$8a,$45,$ea,$05,$0a,$75,$00,$05
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $7c,$00,$04,$3a,$14,$02,$fe,$00,$00,$7f,$40,$00,$7c,$00,$00,$3e
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa44:; // 4: 썬더호크
  db $52,$00,$56,$29,$aa,$01,$aa,$55,$02,$55,$40,$01,$7e,$00,$00,$3f
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $f4,$00,$84,$7a,$9c,$42,$84,$4a,$84,$42,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $10,$00,$fe,$00,$44,$3b,$38,$02,$10,$0c,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $7c,$00,$04,$3a,$7c,$02,$04,$3a,$00,$02,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa45:; // 5: 몰텐
  db $7c,$00,$44,$3a,$10,$22,$fe,$00,$1c,$63,$60,$0e,$7c,$00,$00,$3e
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $ea,$00,$da,$25,$8a,$65,$ea,$05,$0a,$75,$40,$05,$7e,$00,$00,$3f
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa46:; // 6: 트윈헤드
  db $7c,$00,$78,$06,$40,$3c,$7c,$00,$00,$3e,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $64,$00,$94,$22,$64,$0a,$fc,$02,$24,$5a,$40,$12,$7c,$00,$00,$3e
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $4a,$00,$ea,$05,$4a,$35,$ba,$05,$aa,$55,$4a,$15,$0a,$25,$00,$05
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $7c,$00,$40,$3e,$40,$20,$7c,$00,$00,$3e,$fe,$00,$00,$7f,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa47:; // 7: 무니무니
  db $7c,$00,$44,$3a,$7c,$02,$00,$3e,$fe,$00,$10,$6f,$10,$08,$00,$08
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $84,$00,$84,$42,$84,$42,$84,$42,$84,$42,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $7c,$00,$44,$3a,$7c,$02,$00,$3e,$fe,$00,$10,$6f,$10,$08,$00,$08
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $84,$00,$84,$42,$84,$42,$84,$42,$84,$42,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

defaultNameBpa48:; // 8: 파피
  db $f4,$00,$64,$1a,$64,$12,$66,$10,$64,$13,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $f4,$00,$64,$1a,$64,$12,$64,$12,$64,$12,$f4,$02,$04,$7a,$00,$02
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00
  db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  db $ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00,$ff,$00

function noop {
  rtl
}

// Copy one hardcoded Korean default name into the matching renderDefaultToNameBufferBpp2 target slot.
// A => dynamic name index 0..8. Other indexes are ignored.
// If the saved base56 name no longer matches the original English default, do nothing.
function renderDefaultToNameBufferBpp2 {
  php
  phb
  rep #$30
  pha
  phx
  phy

  and #$00ff
  cmp #$0000
  jeq copy0
  cmp #$0001
  jeq copy1
  cmp #$0002
  jeq copy2
  cmp #$0003
  jeq copy3
  cmp #$0004
  jeq copy4
  cmp #$0005
  jeq copy5
  cmp #$0006
  jeq copy6
  cmp #$0007
  jeq copy7
  cmp #$0008
  jeq copy8
  jmp done

  copy0:
    lda.l $7e2b00
    cmp.w #$ffff
    jne done
    lda.l $7e2b02
    cmp.w #$9fff
    jne done
    lda.l $7e2b04
    cmp.w #$6670
    jne done
    lda.l $7e2b06
    cmp.w #$20e3
    jne done
    ldx #$0000
    copy0Bpp2Loop:
      lda.l defaultNameBpp20,x
      sta.l names.buffer.bpp2+$0000,x
      inx #2
      cpx #$0080
      bcc copy0Bpp2Loop
    jmp done

  copy1:
    lda.l $7e2b08
    cmp.w #$ffff
    jne done
    lda.l $7e2b0a
    cmp.w #$4b3f
    jne done
    lda.l $7e2b0c
    cmp.w #$370a
    jne done
    lda.l $7e2b0e
    cmp.w #$81c9
    jne done
    ldx #$0000
    copy1Bpp2Loop:
      lda.l defaultNameBpp21,x
      sta.l names.buffer.bpp2+$0080,x
      inx #2
      cpx #$0080
      bcc copy1Bpp2Loop
    jmp done

  copy2:
    lda.l $7e2b10
    cmp.w #$8de7
    jne done
    lda.l $7e2b12
    cmp.w #$de7d
    jne done
    lda.l $7e2b14
    cmp.w #$d0fe
    jne done
    lda.l $7e2b16
    cmp.w #$54e2
    jne done
    ldx #$0000
    copy2Bpp2Loop:
      lda.l defaultNameBpp22,x
      sta.l names.buffer.bpp2+$0100,x
      inx #2
      cpx #$0080
      bcc copy2Bpp2Loop
    jmp done

  copy3:
    lda.l $7e2b18
    cmp.w #$3247
    jne done
    lda.l $7e2b1a
    cmp.w #$6f12
    jne done
    lda.l $7e2b1c
    cmp.w #$8fd2
    jne done
    lda.l $7e2b1e
    cmp.w #$322d
    jne done
    ldx #$0000
    copy3Bpp2Loop:
      lda.l defaultNameBpp23,x
      sta.l names.buffer.bpp2+$0180,x
      inx #2
      cpx #$0080
      bcc copy3Bpp2Loop
    jmp done

  copy4:
    lda.l $7e2b20
    cmp.w #$c4cd
    jne done
    lda.l $7e2b22
    cmp.w #$171b
    jne done
    lda.l $7e2b24
    cmp.w #$ec81
    jne done
    lda.l $7e2b26
    cmp.w #$5a90
    jne done
    ldx #$0000
    copy4Bpp2Loop:
      lda.l defaultNameBpp24,x
      sta.l names.buffer.bpp2+$0200,x
      inx #2
      cpx #$0080
      bcc copy4Bpp2Loop
    jmp done

  copy5:
    lda.l $7e2b28
    cmp.w #$7fff
    jne done
    lda.l $7e2b2a
    cmp.w #$4edc
    jne done
    lda.l $7e2b2c
    cmp.w #$278f
    jne done
    lda.l $7e2b2e
    cmp.w #$3d05
    jne done
    ldx #$0000
    copy5Bpp2Loop:
      lda.l defaultNameBpp25,x
      sta.l names.buffer.bpp2+$0280,x
      inx #2
      cpx #$0080
      bcc copy5Bpp2Loop
    jmp done

  copy6:
    lda.l $7e2b30
    cmp.w #$bdff
    jne done
    lda.l $7e2b32
    cmp.w #$0b0b
    jne done
    lda.l $7e2b34
    cmp.w #$6c35
    jne done
    lda.l $7e2b36
    cmp.w #$6383
    jne done
    ldx #$0000
    copy6Bpp2Loop:
      lda.l defaultNameBpp26,x
      sta.l names.buffer.bpp2+$0300,x
      inx #2
      cpx #$0080
      bcc copy6Bpp2Loop
    jmp done

  copy7:
    lda.l $7e2b38
    cmp.w #$f0ff
    jne done
    lda.l $7e2b3a
    cmp.w #$7876
    jne done
    lda.l $7e2b3c
    cmp.w #$951d
    jne done
    lda.l $7e2b3e
    cmp.w #$3da4
    jne done
    ldx #$0000
    copy7Bpp2Loop:
      lda.l defaultNameBpp27,x
      sta.l names.buffer.bpp2+$0380,x
      inx #2
      cpx #$0080
      bcc copy7Bpp2Loop
    jmp done

  copy8:
    lda.l $7e2b40
    cmp.w #$ffff
    jne done
    lda.l $7e2b42
    cmp.w #$3a4f
    jne done
    lda.l $7e2b44
    cmp.w #$d3a6
    jne done
    lda.l $7e2b46
    cmp.w #$5f6c
    jne done
    ldx #$0000
    copy8Bpp2Loop:
      lda.l defaultNameBpp28,x
      sta.l names.buffer.bpp2+$0400,x
      inx #2
      cpx #$0080
      bcc copy8Bpp2Loop
    jmp done

  done:
  ply
  plx
  pla
  plb
  plp
  rtl
}

macro copyDefaultNameBpp2AsBpp4(variable source, variable offset) {
  ldb #names.buffer.origin>>16
  ldx #$0000
  ldy #$0000
copyBpp4Tile{#}:
  lda.l source+$00,x; sta.w names.buffer.bpp4+offset+$00,y
  lda.l source+$02,x; sta.w names.buffer.bpp4+offset+$02,y
  lda.l source+$04,x; sta.w names.buffer.bpp4+offset+$04,y
  lda.l source+$06,x; sta.w names.buffer.bpp4+offset+$06,y
  lda.l source+$08,x; sta.w names.buffer.bpp4+offset+$08,y
  lda.l source+$0a,x; sta.w names.buffer.bpp4+offset+$0a,y
  lda.l source+$0c,x; sta.w names.buffer.bpp4+offset+$0c,y
  lda.l source+$0e,x; sta.w names.buffer.bpp4+offset+$0e,y
  lda #$0000
  sta.w names.buffer.bpp4+offset+$10,y
  sta.w names.buffer.bpp4+offset+$12,y
  sta.w names.buffer.bpp4+offset+$14,y
  sta.w names.buffer.bpp4+offset+$16,y
  sta.w names.buffer.bpp4+offset+$18,y
  sta.w names.buffer.bpp4+offset+$1a,y
  sta.w names.buffer.bpp4+offset+$1c,y
  sta.w names.buffer.bpp4+offset+$1e,y
  txa; add #$0010; tax
  tya; add #$0020; tay
  cpx #$0080
  bcc copyBpp4Tile{#}
}

// Copy one hardcoded Korean default name into the matching renderDefaultToNameBufferBpp4 target slot.
// A => dynamic name index 0..8. Other indexes are ignored.
// If the saved base56 name no longer matches the original English default, do nothing.
function renderDefaultToNameBufferBpp4 {
  php
  phb
  rep #$30
  pha
  phx
  phy

  and #$00ff
  cmp #$0000
  jeq copy0
  cmp #$0001
  jeq copy1
  cmp #$0002
  jeq copy2
  cmp #$0003
  jeq copy3
  cmp #$0004
  jeq copy4
  cmp #$0005
  jeq copy5
  cmp #$0006
  jeq copy6
  cmp #$0007
  jeq copy7
  cmp #$0008
  jeq copy8
  jmp done

  copy0:
    lda.l $7e2b00
    cmp.w #$ffff
    jne done
    lda.l $7e2b02
    cmp.w #$9fff
    jne done
    lda.l $7e2b04
    cmp.w #$6670
    jne done
    lda.l $7e2b06
    cmp.w #$20e3
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp20, $0000)
    ldx #$0000
    copy0Bpo4Loop:
      lda.l defaultNameBpo40,x
      sta.l names.buffer.bpo4+$0000,x
      inx #2
      cpx #$0100
      bcc copy0Bpo4Loop
    ldx #$0000
    copy0Bpa4Loop:
      lda.l defaultNameBpa40,x
      sta.l names.buffer.bpa4+$0000,x
      inx #2
      cpx #$0100
      bcc copy0Bpa4Loop
    jmp done

  copy1:
    lda.l $7e2b08
    cmp.w #$ffff
    jne done
    lda.l $7e2b0a
    cmp.w #$4b3f
    jne done
    lda.l $7e2b0c
    cmp.w #$370a
    jne done
    lda.l $7e2b0e
    cmp.w #$81c9
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp21, $0100)
    ldx #$0000
    copy1Bpo4Loop:
      lda.l defaultNameBpo41,x
      sta.l names.buffer.bpo4+$0100,x
      inx #2
      cpx #$0100
      bcc copy1Bpo4Loop
    ldx #$0000
    copy1Bpa4Loop:
      lda.l defaultNameBpa41,x
      sta.l names.buffer.bpa4+$0100,x
      inx #2
      cpx #$0100
      bcc copy1Bpa4Loop
    jmp done

  copy2:
    lda.l $7e2b10
    cmp.w #$8de7
    jne done
    lda.l $7e2b12
    cmp.w #$de7d
    jne done
    lda.l $7e2b14
    cmp.w #$d0fe
    jne done
    lda.l $7e2b16
    cmp.w #$54e2
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp22, $0200)
    ldx #$0000
    copy2Bpo4Loop:
      lda.l defaultNameBpo42,x
      sta.l names.buffer.bpo4+$0200,x
      inx #2
      cpx #$0100
      bcc copy2Bpo4Loop
    ldx #$0000
    copy2Bpa4Loop:
      lda.l defaultNameBpa42,x
      sta.l names.buffer.bpa4+$0200,x
      inx #2
      cpx #$0100
      bcc copy2Bpa4Loop
    jmp done

  copy3:
    lda.l $7e2b18
    cmp.w #$3247
    jne done
    lda.l $7e2b1a
    cmp.w #$6f12
    jne done
    lda.l $7e2b1c
    cmp.w #$8fd2
    jne done
    lda.l $7e2b1e
    cmp.w #$322d
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp23, $0300)
    ldx #$0000
    copy3Bpo4Loop:
      lda.l defaultNameBpo43,x
      sta.l names.buffer.bpo4+$0300,x
      inx #2
      cpx #$0100
      bcc copy3Bpo4Loop
    ldx #$0000
    copy3Bpa4Loop:
      lda.l defaultNameBpa43,x
      sta.l names.buffer.bpa4+$0300,x
      inx #2
      cpx #$0100
      bcc copy3Bpa4Loop
    jmp done

  copy4:
    lda.l $7e2b20
    cmp.w #$c4cd
    jne done
    lda.l $7e2b22
    cmp.w #$171b
    jne done
    lda.l $7e2b24
    cmp.w #$ec81
    jne done
    lda.l $7e2b26
    cmp.w #$5a90
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp24, $0400)
    ldx #$0000
    copy4Bpo4Loop:
      lda.l defaultNameBpo44,x
      sta.l names.buffer.bpo4+$0400,x
      inx #2
      cpx #$0100
      bcc copy4Bpo4Loop
    ldx #$0000
    copy4Bpa4Loop:
      lda.l defaultNameBpa44,x
      sta.l names.buffer.bpa4+$0400,x
      inx #2
      cpx #$0100
      bcc copy4Bpa4Loop
    jmp done

  copy5:
    lda.l $7e2b28
    cmp.w #$7fff
    jne done
    lda.l $7e2b2a
    cmp.w #$4edc
    jne done
    lda.l $7e2b2c
    cmp.w #$278f
    jne done
    lda.l $7e2b2e
    cmp.w #$3d05
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp25, $0500)
    ldx #$0000
    copy5Bpo4Loop:
      lda.l defaultNameBpo45,x
      sta.l names.buffer.bpo4+$0500,x
      inx #2
      cpx #$0100
      bcc copy5Bpo4Loop
    ldx #$0000
    copy5Bpa4Loop:
      lda.l defaultNameBpa45,x
      sta.l names.buffer.bpa4+$0500,x
      inx #2
      cpx #$0100
      bcc copy5Bpa4Loop
    jmp done

  copy6:
    lda.l $7e2b30
    cmp.w #$bdff
    jne done
    lda.l $7e2b32
    cmp.w #$0b0b
    jne done
    lda.l $7e2b34
    cmp.w #$6c35
    jne done
    lda.l $7e2b36
    cmp.w #$6383
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp26, $0600)
    ldx #$0000
    copy6Bpo4Loop:
      lda.l defaultNameBpo46,x
      sta.l names.buffer.bpo4+$0600,x
      inx #2
      cpx #$0100
      bcc copy6Bpo4Loop
    ldx #$0000
    copy6Bpa4Loop:
      lda.l defaultNameBpa46,x
      sta.l names.buffer.bpa4+$0600,x
      inx #2
      cpx #$0100
      bcc copy6Bpa4Loop
    jmp done

  copy7:
    lda.l $7e2b38
    cmp.w #$f0ff
    jne done
    lda.l $7e2b3a
    cmp.w #$7876
    jne done
    lda.l $7e2b3c
    cmp.w #$951d
    jne done
    lda.l $7e2b3e
    cmp.w #$3da4
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp27, $0700)
    ldx #$0000
    copy7Bpo4Loop:
      lda.l defaultNameBpo47,x
      sta.l names.buffer.bpo4+$0700,x
      inx #2
      cpx #$0100
      bcc copy7Bpo4Loop
    ldx #$0000
    copy7Bpa4Loop:
      lda.l defaultNameBpa47,x
      sta.l names.buffer.bpa4+$0700,x
      inx #2
      cpx #$0100
      bcc copy7Bpa4Loop
    jmp done

  copy8:
    lda.l $7e2b40
    cmp.w #$ffff
    jne done
    lda.l $7e2b42
    cmp.w #$3a4f
    jne done
    lda.l $7e2b44
    cmp.w #$d3a6
    jne done
    lda.l $7e2b46
    cmp.w #$5f6c
    jne done
    copyDefaultNameBpp2AsBpp4(defaultNameBpp28, $0800)
    ldx #$0000
    copy8Bpo4Loop:
      lda.l defaultNameBpo48,x
      sta.l names.buffer.bpo4+$0800,x
      inx #2
      cpx #$0100
      bcc copy8Bpo4Loop
    ldx #$0000
    copy8Bpa4Loop:
      lda.l defaultNameBpa48,x
      sta.l names.buffer.bpa4+$0800,x
      inx #2
      cpx #$0100
      bcc copy8Bpa4Loop
    jmp done

  done:
  ply
  plx
  pla
  plb
  plp
  rtl
}


// Render one compact KO 12x12 glyph into the menu-large name-entry preview.
// Called only from menu.largeText while DB=$7e and M/X are 16-bit.
function renderMenuLargeViewGlyph {
  lda.w #$00f0
  sta.l menu.largeText.character
  jml renderMenuLargeKoGlyphLoaded
}


// Name-entry display-only proxy bytes. Each proxy is one editable byte in
// $7e9e00, but renders as one compact KO 12x12 syllable on the preview line.
// $a8-$c1 are handled only while menu.largeText.type == nameEntry.
nameEntryProxyGlyphs:
  dw $00f0  //a8 뷰
  dw $0033  //a9 요
  dw $009a  //aa 살
  dw $0028  //ab 라
  dw $00f1  //ac 맨
  dw $009c  //ad 더
  dw $0002  //ae 아
  dw $0016  //af 이
  dw $003a  //b0 스
  dw $003f  //b1 드
  dw $0040  //b2 래
  dw $0041  //b3 곤
  dw $00f2  //b4 썬
  dw $003e  //b5 호
  dw $0045  //b6 크
  dw $00f3  //b7 몰
  dw $00f4  //b8 텐
  dw $0013  //b9 트
  dw $00f5  //ba 윈
  dw $00f6  //bb 헤
  dw $0012  //bc 무
  dw $0003  //bd 니
  dw $00d4  //be 파
  dw $00f7  //bf 피
  dw $00f8  //c0 렌
  dw $0011  //c1 하

function renderMenuLargeNameEntryProxy {
  and #$00ff
  sub #$00a8
  asl
  tax
  lda.l nameEntryProxyGlyphs,x
  sta.l menu.largeText.character
  jml renderMenuLargeKoGlyphLoaded
}


// A <= width in pixels for a name-entry proxy alias. C set when the current
// $7e9e00 buffer starts with a KO proxy byte; C clear for normal English names.
function nameEntryAliasWidth {
  php
  phb
  rep #$30
  phx

  ldb #$7e
  lda.w $9e00; and #$00ff
  cmp.w #menu.koNameEntry.proxyBase
  bcc noAlias
  cmp.w #menu.koNameEntry.proxyLimit
  bcs noAlias

  ldx #$0000
  lda #$0000
loop:
  pha
  lda.w $9e00,x; and #$00ff
  cmp.w #command.terminal
  beq done
  pla
  add #$000c
  inx
  cpx #$000c
  bcc loop
  bra doneNoPull

done:
  pla
doneNoPull:
  plx
  plb
  plp
  sec
  rtl

noAlias:
  plx
  plb
  plp
  clc
  rtl
}

function renderMenuLargeKoGlyph {
  ldy.b menu.largeText.index
  lda [menu.largeText.buffer],y; and #$00ff; sta.l menu.largeText.character
  iny
  lda [menu.largeText.buffer],y; and #$00ff; xba; add.l menu.largeText.character; sta.l menu.largeText.character
  iny; sty.b menu.largeText.index

  jml renderMenuLargeKoGlyphLoaded
}

function renderMenuLargeKoGlyphLoaded {
  //calculate first RAM tile write position
  lda.l menu.largeText.pixel; and #$00f8; asl #2; cmp #$0200; bcc +
  add #$0200; +; sta.l menu.largeText.ramAddressL

  //calculate second RAM tile write position
  lda.l menu.largeText.pixel; add #$0008; and #$00f8; asl #2; cmp #$0200; bcc +
  add #$0200; +; sta.l menu.largeText.ramAddressR

  //select one of the two generated KO large shift pages (0px or 4px)
  lda.l menu.largeText.pixel; and #$0004; beq +; lda.w #$3000; bra ++; +; lda.w #$0000; +
  pha; lda.l menu.largeText.character; mul(48); add $01,s; tax; pla

  lda.l menu.largeText.pixel; add #$000c; cmp.l menu.largeText.pixels; bcc +; beq +
  lda.l menu.largeText.pixels; sta.l menu.largeText.pixel; rtl
+;sta.l menu.largeText.pixel

  lda.l menu.largeText.color; jne yellowKo

  macro tileKo(variable font) {
    macro lineL(variable n) {
      //menu.largeText.output is arranged as two 8px-high sprite rows.
      //The proportional 11px font uses a one-row baseline offset, but the KO
      //compact font is a true 12px glyph. Split it as 6 top rows + 6 bottom
      //rows; using the old 11px formula for line 11 wrapped into the next
      //sprite quadrant and produced stray icon garbage on the name screen.
      variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
      lda.l font+$00+n*2,x; ora.w menu.largeText.output+r,y; sta.w menu.largeText.output+r,y
    }
    lda.l menu.largeText.ramAddressL; tay
    lineL(0); lineL(1); lineL(2);  lineL(3);  lineL(4);  lineL(5)
    lineL(6); lineL(7); lineL(8);  lineL(9);  lineL(10); lineL(11)
    macro lineR(variable n) {
      variable r = n < 6 ? n * 2 : $01fc + (n - 6) * 2
      lda.l font+$18+n*2,x; ora.w menu.largeText.output+r,y; sta.w menu.largeText.output+r,y
    }
    lda.l menu.largeText.ramAddressR; tay
    lineR(0); lineR(1); lineR(2);  lineR(3);  lineR(4);  lineR(5)
    lineR(6); lineR(7); lineR(8);  lineR(9);  lineR(10); lineR(11)
    rtl
  }

  normalKo:; tileKo(koLargeFont.normal)
  yellowKo:; tileKo(koLargeFont.yellow)
}


// Original English base56 payloads for all name-entry defaults, including
// Fahrenheit. These are kept as saved data when a KO preview alias is accepted
// unchanged.
nameEntryDefaults:
  dw $ffff,$9fff,$6670,$20e3  //0 Byuu
  dw $ffff,$4b3f,$370a,$81c9  //1 Yoyo
  dw $8de7,$de7d,$d0fe,$54e2  //2 Salamander
  dw $3247,$6f12,$8fd2,$322d  //3 Ice Dragon
  dw $c4cd,$171b,$ec81,$5a90  //4 Thunderhawk
  dw $7fff,$4edc,$278f,$3d05  //5 Molten
  dw $bdff,$0b0b,$6c35,$6383  //6 Twinhead
  dw $f0ff,$7876,$951d,$3da4  //7 Muni-Muni
  dw $ffff,$3a4f,$d3a6,$5f6c  //8 Puppy
  dw $2ef7,$9a9c,$8631,$11b9  //9 Fahrenheit

// Fixed-width 12-byte strings for $7e9e00. Bytes are proxy syllables followed
// by terminal padding, never raw multi-byte KO commands.
nameEntryAliases:
  db $a8,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //뷰
  db $a9,$a9,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //요요
  db $aa,$ab,$ac,$ad,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //살라맨더
  db $ae,$af,$b0,$b1,$b2,$b3,$ff,$ff,$ff,$ff,$ff,$ff  //아이스드래곤
  db $b4,$ad,$b5,$b6,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //썬더호크
  db $b7,$b8,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //몰텐
  db $b9,$ba,$bb,$b1,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //트윈헤드
  db $bc,$bd,$bc,$bd,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //무니무니
  db $be,$bf,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //파피
  db $be,$c0,$c1,$af,$b9,$ff,$ff,$ff,$ff,$ff,$ff,$ff  //파렌하이트

function writeDefaultNameEntryAlias {
  php
  phb
  rep #$30
  phx
  phy

  and #$00ff
  cmp #$000a
  bcc +
  jmp noAlias
+;sta largeNameIndex
  mul(8)
  tax
  lda.l nameEntryDefaults+0,x; cmp.l $7e2b00,x; beq +; jmp noAlias; +
  lda.l nameEntryDefaults+2,x; cmp.l $7e2b02,x; beq +; jmp noAlias; +
  lda.l nameEntryDefaults+4,x; cmp.l $7e2b04,x; beq +; jmp noAlias; +
  lda.l nameEntryDefaults+6,x; cmp.l $7e2b06,x; beq +; jmp noAlias; +

  lda largeNameIndex
  mul(12)
  tax
  ldb #$7e
  ldy #$0000
  sep #$20
copyAlias:
  lda.l nameEntryAliases,x
  sta.w $9e00,y
  inx
  iny
  cpy #$000c
  bcc copyAlias
  rep #$20
  ply
  plx
  plb
  plp
  sec
  rtl

noAlias:
  ply
  plx
  plb
  plp
  clc
  rtl
}

function storeDefaultFromNameEntryAlias {
  php
  phb
  rep #$30
  phx
  phy

  and #$00ff
  cmp #$000a
  bcc +
  jmp noAlias
+;sta largeNameIndex
  mul(12)
  tax
  ldb #$7e
  ldy #$0000
  sep #$20
compareAlias:
  lda.l nameEntryAliases,x
  cmp.w $9e00,y
  bne noAlias8
  inx
  iny
  cpy #$000c
  bcc compareAlias

  rep #$20
  lda largeNameIndex
  mul(8)
  tax
  lda.l nameEntryDefaults+0,x; sta.l $7e2b00,x
  lda.l nameEntryDefaults+2,x; sta.l $7e2b02,x
  lda.l nameEntryDefaults+4,x; sta.l $7e2b04,x
  lda.l nameEntryDefaults+6,x; sta.l $7e2b06,x
  ply
  plx
  plb
  plp
  sec
  rtl

noAlias8:
  rep #$20
noAlias:
  ply
  plx
  plb
  plp
  clc
  rtl
}

// Compact KO 12x12 glyph indexes for default dynamic-name aliases.
// These indexes come from bahamut/ko/tables/ko-large-glyphs.tsv after
// apply_chapter_ko_poc.py seeds NAME_ENTRY_LARGE_GLYPHS.
variable(2, largeNameIndex)

largeNameDefaults:
  dw $ffff,$9fff,$6670,$20e3  //0 Byuu
  dw $ffff,$4b3f,$370a,$81c9  //1 Yoyo
  dw $8de7,$de7d,$d0fe,$54e2  //2 Salamander
  dw $3247,$6f12,$8fd2,$322d  //3 Ice Dragon
  dw $c4cd,$171b,$ec81,$5a90  //4 Thunderhawk
  dw $7fff,$4edc,$278f,$3d05  //5 Molten
  dw $bdff,$0b0b,$6c35,$6383  //6 Twinhead
  dw $f0ff,$7876,$951d,$3da4  //7 Muni-Muni
  dw $ffff,$3a4f,$d3a6,$5f6c  //8 Puppy

function isDefaultDynamicName {
  php
  rep #$30
  phx

  and #$00ff
  cmp #$0009
  bcc +
  jmp noAlias
+;mul(8)
  tax
  lda.l largeNameDefaults+0,x; cmp.l $7e2b00,x; beq +; jmp noAlias; +
  lda.l largeNameDefaults+2,x; cmp.l $7e2b02,x; beq +; jmp noAlias; +
  lda.l largeNameDefaults+4,x; cmp.l $7e2b04,x; beq +; jmp noAlias; +
  lda.l largeNameDefaults+6,x; cmp.l $7e2b06,x; beq +; jmp noAlias; +

  plx
  plp
  sec
  rtl

noAlias:
  plx
  plp
  clc
  rtl
}

macro appendLargeGlyphToChapter(variable glyph) {
  sep #$20
  lda.b #command.reserved0; sta.l chapter.renderLargeText.text,x; inx
  lda.b #glyph >> 0;       sta.l chapter.renderLargeText.text,x; inx
  lda.b #glyph >> 8;       sta.l chapter.renderLargeText.text,x; inx
  rep #$20
}

macro appendLargeGlyphToField(variable glyph) {
  sep #$20
  lda.b #command.reserved0; sta.l field.renderLargeText.text,x; inx
  lda.b #glyph >> 0;       sta.l field.renderLargeText.text,x; inx
  lda.b #glyph >> 8;       sta.l field.renderLargeText.text,x; inx
  rep #$20
}

macro appendLargeGlyphToRenderText(variable glyph) {
  sep #$20
  lda.b #command.reserved0; sta.l render.text,x; inx
  lda.b #glyph >> 0;       sta.l render.text,x; inx
  lda.b #glyph >> 8;       sta.l render.text,x; inx
  rep #$20
}


// Append a compact KO 12x12 dynamic-name alias into chapter.renderLargeText.text.
// A => dynamic name index, X => output index. C set when appended.
function appendChapterLargeNameAlias {
  rep #$30
  and #$00ff
  sta largeNameIndex
  jsl isDefaultDynamicName
  bcs +
  jmp noAlias
+;lda largeNameIndex
  cmp #$0000
  beq chapterCase0
  jmp chapterNext0
chapterCase0:
  appendLargeGlyphToChapter($00f0)  //뷰
  jmp aliasDone
chapterNext0:
  cmp #$0001
  beq chapterCase1
  jmp chapterNext1
chapterCase1:
  appendLargeGlyphToChapter($0033)  //요
  appendLargeGlyphToChapter($0033)  //요
  jmp aliasDone
chapterNext1:
  cmp #$0002
  beq chapterCase2
  jmp chapterNext2
chapterCase2:
  appendLargeGlyphToChapter($009a)  //살
  appendLargeGlyphToChapter($0028)  //라
  appendLargeGlyphToChapter($00f1)  //맨
  appendLargeGlyphToChapter($009c)  //더
  jmp aliasDone
chapterNext2:
  cmp #$0003
  beq chapterCase3
  jmp chapterNext3
chapterCase3:
  appendLargeGlyphToChapter($0002)  //아
  appendLargeGlyphToChapter($0016)  //이
  appendLargeGlyphToChapter($003a)  //스
  appendLargeGlyphToChapter($003f)  //드
  appendLargeGlyphToChapter($0040)  //래
  appendLargeGlyphToChapter($0041)  //곤
  jmp aliasDone
chapterNext3:
  cmp #$0004
  beq chapterCase4
  jmp chapterNext4
chapterCase4:
  appendLargeGlyphToChapter($00f2)  //썬
  appendLargeGlyphToChapter($009c)  //더
  appendLargeGlyphToChapter($003e)  //호
  appendLargeGlyphToChapter($0045)  //크
  jmp aliasDone
chapterNext4:
  cmp #$0005
  beq chapterCase5
  jmp chapterNext5
chapterCase5:
  appendLargeGlyphToChapter($00f3)  //몰
  appendLargeGlyphToChapter($00f4)  //텐
  jmp aliasDone
chapterNext5:
  cmp #$0006
  beq chapterCase6
  jmp chapterNext6
chapterCase6:
  appendLargeGlyphToChapter($0013)  //트
  appendLargeGlyphToChapter($00f5)  //윈
  appendLargeGlyphToChapter($00f6)  //헤
  appendLargeGlyphToChapter($003f)  //드
  jmp aliasDone
chapterNext6:
  cmp #$0007
  beq chapterCase7
  jmp chapterNext7
chapterCase7:
  appendLargeGlyphToChapter($0012)  //무
  appendLargeGlyphToChapter($0003)  //니
  appendLargeGlyphToChapter($0012)  //무
  appendLargeGlyphToChapter($0003)  //니
  jmp aliasDone
chapterNext7:
  cmp #$0008
  beq chapterCase8
  jmp chapterNext8
chapterCase8:
  appendLargeGlyphToChapter($00d4)  //파
  appendLargeGlyphToChapter($00f7)  //피
  jmp aliasDone
chapterNext8:
  jmp noAlias

aliasDone:
  sec
  rtl

noAlias:
  clc
  rtl
}

// Append a compact KO 12x12 dynamic-name alias into field.renderLargeText.text.
// A => dynamic name index, X => output index. C set when appended.
function appendFieldLargeNameAlias {
  rep #$30
  and #$00ff
  sta largeNameIndex
  jsl isDefaultDynamicName
  bcs +
  jmp noAlias
+;lda largeNameIndex
  cmp #$0000
  beq fieldCase0
  jmp fieldNext0
fieldCase0:
  appendLargeGlyphToField($00f0)  //뷰
  jmp aliasDone
fieldNext0:
  cmp #$0001
  beq fieldCase1
  jmp fieldNext1
fieldCase1:
  appendLargeGlyphToField($0033)  //요
  appendLargeGlyphToField($0033)  //요
  jmp aliasDone
fieldNext1:
  cmp #$0002
  beq fieldCase2
  jmp fieldNext2
fieldCase2:
  appendLargeGlyphToField($009a)  //살
  appendLargeGlyphToField($0028)  //라
  appendLargeGlyphToField($00f1)  //맨
  appendLargeGlyphToField($009c)  //더
  jmp aliasDone
fieldNext2:
  cmp #$0003
  beq fieldCase3
  jmp fieldNext3
fieldCase3:
  appendLargeGlyphToField($0002)  //아
  appendLargeGlyphToField($0016)  //이
  appendLargeGlyphToField($003a)  //스
  appendLargeGlyphToField($003f)  //드
  appendLargeGlyphToField($0040)  //래
  appendLargeGlyphToField($0041)  //곤
  jmp aliasDone
fieldNext3:
  cmp #$0004
  beq fieldCase4
  jmp fieldNext4
fieldCase4:
  appendLargeGlyphToField($00f2)  //썬
  appendLargeGlyphToField($009c)  //더
  appendLargeGlyphToField($003e)  //호
  appendLargeGlyphToField($0045)  //크
  jmp aliasDone
fieldNext4:
  cmp #$0005
  beq fieldCase5
  jmp fieldNext5
fieldCase5:
  appendLargeGlyphToField($00f3)  //몰
  appendLargeGlyphToField($00f4)  //텐
  jmp aliasDone
fieldNext5:
  cmp #$0006
  beq fieldCase6
  jmp fieldNext6
fieldCase6:
  appendLargeGlyphToField($0013)  //트
  appendLargeGlyphToField($00f5)  //윈
  appendLargeGlyphToField($00f6)  //헤
  appendLargeGlyphToField($003f)  //드
  jmp aliasDone
fieldNext6:
  cmp #$0007
  beq fieldCase7
  jmp fieldNext7
fieldCase7:
  appendLargeGlyphToField($0012)  //무
  appendLargeGlyphToField($0003)  //니
  appendLargeGlyphToField($0012)  //무
  appendLargeGlyphToField($0003)  //니
  jmp aliasDone
fieldNext7:
  cmp #$0008
  beq fieldCase8
  jmp fieldNext8
fieldCase8:
  appendLargeGlyphToField($00d4)  //파
  appendLargeGlyphToField($00f7)  //피
  jmp aliasDone
fieldNext8:
  jmp noAlias

aliasDone:
  sec
  rtl

noAlias:
  clc
  rtl
}

// Build render.text from a compact KO 12x12 dynamic-name alias for direct renderers.
// A => dynamic name index, X => output index. C set when appended.
function appendRenderTextLargeNameAlias {
  rep #$30
  and #$00ff
  sta largeNameIndex
  jsl isDefaultDynamicName
  bcs +
  jmp noAlias
+;lda largeNameIndex
  cmp #$0000
  beq renderTextCase0
  jmp renderTextNext0
renderTextCase0:
  appendLargeGlyphToRenderText($00f0)  //뷰
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext0:
  cmp #$0001
  beq renderTextCase1
  jmp renderTextNext1
renderTextCase1:
  appendLargeGlyphToRenderText($0033)  //요
  appendLargeGlyphToRenderText($0033)  //요
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext1:
  cmp #$0002
  beq renderTextCase2
  jmp renderTextNext2
renderTextCase2:
  appendLargeGlyphToRenderText($009a)  //살
  appendLargeGlyphToRenderText($0028)  //라
  appendLargeGlyphToRenderText($00f1)  //맨
  appendLargeGlyphToRenderText($009c)  //더
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext2:
  cmp #$0003
  beq renderTextCase3
  jmp renderTextNext3
renderTextCase3:
  appendLargeGlyphToRenderText($0002)  //아
  appendLargeGlyphToRenderText($0016)  //이
  appendLargeGlyphToRenderText($003a)  //스
  appendLargeGlyphToRenderText($003f)  //드
  appendLargeGlyphToRenderText($0040)  //래
  appendLargeGlyphToRenderText($0041)  //곤
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext3:
  cmp #$0004
  beq renderTextCase4
  jmp renderTextNext4
renderTextCase4:
  appendLargeGlyphToRenderText($00f2)  //썬
  appendLargeGlyphToRenderText($009c)  //더
  appendLargeGlyphToRenderText($003e)  //호
  appendLargeGlyphToRenderText($0045)  //크
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext4:
  cmp #$0005
  beq renderTextCase5
  jmp renderTextNext5
renderTextCase5:
  appendLargeGlyphToRenderText($00f3)  //몰
  appendLargeGlyphToRenderText($00f4)  //텐
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext5:
  cmp #$0006
  beq renderTextCase6
  jmp renderTextNext6
renderTextCase6:
  appendLargeGlyphToRenderText($0013)  //트
  appendLargeGlyphToRenderText($00f5)  //윈
  appendLargeGlyphToRenderText($00f6)  //헤
  appendLargeGlyphToRenderText($003f)  //드
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext6:
  cmp #$0007
  beq renderTextCase7
  jmp renderTextNext7
renderTextCase7:
  appendLargeGlyphToRenderText($0012)  //무
  appendLargeGlyphToRenderText($0003)  //니
  appendLargeGlyphToRenderText($0012)  //무
  appendLargeGlyphToRenderText($0003)  //니
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext7:
  cmp #$0008
  beq renderTextCase8
  jmp renderTextNext8
renderTextCase8:
  appendLargeGlyphToRenderText($00d4)  //파
  appendLargeGlyphToRenderText($00f7)  //피
  sep #$20
  lda.b #command.terminal; sta.l render.text,x; inx
  rep #$20
  jmp aliasDone
renderTextNext8:
  jmp noAlias

aliasDone:
  sec
  rtl

noAlias:
  clc
  rtl
}

codeCursor = pc()

}
