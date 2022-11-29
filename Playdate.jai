// SYSTEM //////////////////////////////////////////////////////////////////////
PDButtons :: enum {
    LEFT    :: #run -> int { return 1<<0; }; //kButtonLeft
    RIGHT   :: #run -> int { return 1<<1; }; //kButtonRight
    UP      :: #run -> int { return 1<<2; }; //kButtonUp
    DOWN    :: #run -> int { return 1<<3; }; //kButtonDown
    B       :: #run -> int { return 1<<4; }; //kButtonB
    A       :: #run -> int { return 1<<5; }; //kButtonA
}

PDLanguage :: enum {
    ENGLISH;    //kPDLanguageEnglish
    JAPANESE;   //kPDLanguageJapanese
    UNKNONW;    //kPDLanguageUnknown
}

PDMenuItem :: #type void; //TODO: CHECK

PDPeripherals :: enum {
    NONE            :: 0;                               //kNone
    ACCELEROMETER   :: #run -> int { return 1<<0; };    //kAccelerometer
    ALL             :: 0xffff;                          //kAllPeripherals
}

PDCallbackFunction          :: #type (userdata: *void) -> int #c_call;
PDMenuItemCallbackFunction  :: #type (userdata: *void) #c_call;

playdate_sys :: struct {
    realloc:                    (ptr: *void, size: size_t) -> *void #c_call;
    formatString:               (ret: **u8, fmt: *u8, __args: ..Any) #c_call;
    logToConsole:               (fmt: *u8, __args: ..Any) #c_call;
    error:                      (fmt: *u8, __args: ..Any) #c_call;
    getLanguage:                () -> PDLanguage #c_call;
    getCurrentTimeMilliseconds: () -> u32 #c_call;
    getSecondsSinceEpoch:       (milliseconds: *u32) -> u32 #c_call;
    drawFPS:                    (x: int, y: int) #c_call;

    setUpdateCallback:          (update: PDCallbackFunction, userdata: *void) #c_call;
    getButtonState:             (current: *PDButtons, pushed: *PDButtons, released: *PDButtons) #c_call;
    setPeripheralsEnabled:      (mask: PDPeripherals) #c_call;
    getAccelerometer:           (outx: *float, outy: *float, outz: *float) #c_call;

    getCrankChange:             () -> float #c_call;
    getCrankAngle:              () -> float #c_call;
    isCrankDocked:              () -> int #c_call;
    setCrankSoundsDisabled:     (flag: int) -> int #c_call;

    getFlipped:                 () -> int #c_call;
    setAutoLockDisabled:        (disable: int) #c_call;

    setMenuImage:               (bitmap: *LCDBitmap, xOffset: int) #c_call;
    addMenuItem:                (title: *u8, callback: PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem #c_call;
    addCheckmarkMenuItem:       (title: *u8, callback: PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem #c_call;
    addOptionsMenuItem:         (title: *u8, optionTitles: **u8, optionsCount: int, callback: PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem #c_call;
    removeAllMenuItems:         () #c_call;
    removeMenuItem:             (menuItem: *PDMenuItem) #c_call;
    getMenuItemValue:           (menuItem: *PDMenuItem) -> int #c_call;
    setMenuItemValue:           (menuItem: *PDMenuItem, value: int) #c_call;
    getMenuItemTitle:           (menuItem: *PDMenuItem) -> *u8 #c_call;
    setMenuItemTitle:           (menuItem: *PDMenuItem, title: *u8) #c_call;
    getMenuItemUserdata:        (menuItem: *PDMenuItem) -> *void #c_call;
    setMenuItemUserdata:        (menuItem: *PDMenuItem, userdata: *void) #c_call;

    getReduceFlashing:          () -> int #c_call;

    getElapsedTime:             () -> float #c_call;
    resetElapsedTime:           () #c_call;

    getBatteryPercentage:       () -> float #c_call;
    getBatteryVoltage:          () -> float #c_call;
}


// FILE ////////////////////////////////////////////////////////////////////////
SDFile :: #type void; //TODO: CHECK

FileOptions :: enum {
    READ            :: #run -> int { return 1<<0; }; //kFileRead
    READ_DATA       :: #run -> int { return 1<<1; }; //kFileReadData
    WRITE           :: #run -> int { return 1<<2; }; //kFileWrite
    WRITE_APPEND    :: #run -> int { return 2<<2; }; //kFileWriteAppend
}

FileStat :: struct {
    isdir:      int;
    size:       u32;
    m_year:     int;
    m_month:    int;
    m_day:      int;
    m_hour:     int;
    m_minute:   int;
    m_second:   int;
}

SEEK_SET :: 0;
SEEK_CUR :: 1;
SEEK_END :: 2;

playdate_file :: struct {
    geterr:     () -> *u8 #c_call;
    listfiles:  (path: *u8, callback: (path: *u8, userdata: *void), userdata: *void) -> int #c_call;
    stat:       (path: *u8, stat: *FileStat) -> int #c_call;
    mkdir:      (path: *u8) -> int #c_call;
    unlink:     (name: *u8, recursive: int) -> int #c_call;
    rename:     (from: *u8, to: *u8) -> int #c_call;

    open:       (name: *u8, mode: FileOptions) -> *SDFile #c_call;
    close:      (file: *SDFile) -> int #c_call;
    read:       (file: *SDFile, buf: *void, len: u32) -> int #c_call;
    write:      (file: *SDFile, buf: *void, len: u32) -> int #c_call;
    flush:      (file: *SDFile) -> int #c_call;
    tell:       (file: *SDFile) -> int #c_call;
    seek:       (file: *SDFile, pos: int, whence: int) -> int #c_call;
}


// GRAPHICS ////////////////////////////////////////////////////////////////////
LCDRect :: struct {
    left, right, top, bottom: int;
}

LCDMakeRect :: inline (x: int, y: int, width: int, height: int) -> LCDRect { return .{ x, x+width, y, y+height }; }

LCDRect_translate :: inline (r: LCDRect, dx: int, dy: int) -> LCDRect { return .{ r.left+dx, r.right+dx, r.top+dy, r.bottom+dy }; }

LCD_COLUMNS     :: 400;
LCD_ROWS        :: 240;
LCD_ROWSIZE     :: 52;
LCD_SCREEN_RECT :: #run LCDMakeRect(0, 0, LCD_COLUMNS, LCD_ROWS);

LCDBitmapDrawMode :: enum {
    COPY;               //kDrawModeCopy
    WHITE_TRANSPARENT;  //kDrawModeWhiteTransparent
    BLACK_TRANSPARENT;  //kDrawModeBlackTransparent
    FILL_WHITE;         //kDrawModeFillWhite
    FILL_BLACK;         //kDrawModeFillBlack
    XOR;                //kDrawModeXOR
    NXOR;               //kDrawModeNXOR
    INVERTED;           //kDrawModeInverted
}

LCDBitmapFlip :: enum {
    UNFLIPPED;  //kBitmapUnflipped
    FLIPPED_X;  //kBitmapFlippedX
    FLIPPED_Y;  //kBitmapFlippedY
    FLIPPED_XY; //kBitmapFlippedXY
}

LCDSolidColor :: enum {
    BLACK;  //kColorBlack
    WHITE;  //kColorWhite
    CLEAR;  //kColorClear
    XOR;    //kColorXOR
}

LCDLineCapStyle :: enum {
    BUTT;   //kLineCapStyleButt
    SQUARE; //kLineCapStyleSquare
    ROUND;  //kLineCapStyleRound
}

LCDFontLanguage :: enum {
    ENGLISH;    //kLCDFontLanguageEnglish
    JAPANESE;   //kLCDFontLanguageJapanese
    UNKNOWN;    //kLCDFontLanguageUnknown
}

PDStringEncoding :: enum {
    ASCII;          //kASCIIEncoding;
    UTF8;           //kUTF8Encoding;
    SIXTEENBITLE;   //k16BitLEEncoding;
}

LCDPattern  :: #type [16] uint8_t; //TODO: CHECK
LCDColor    :: #type uintptr_t; //TODO: CHECK

// LCDMakePattern   //TODO
// LCDOpaquePattern //TODO

LCDMakeOpaque :: inline (r0: u8, r1: u8, r2: u8, r3: u8, r4: u8, r5: u8, r6: u8, r7: u8) -> LCDPattern {
    return .{r0, r1, r2, r3, r4, r5, r6, r7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
}

LCDPolygonFillRule :: enum {
    NON_ZERO; //kPolygonFillNonZero
    EVEN_ODD; //kPolygonFillEvenOdd
}

LCDBitmap       :: #type void; //TODO: CHECK
LCDBitmapTable  :: #type void; //TODO: CHECK
LCDFont         :: #type void; //TODO: CHECK
LCDFontPage     :: #type void; //TODO: CHECK
LCDFontGlyph    :: #type void; //TODO: CHECK
LCDVideoPlayer  :: #type void; //TODO: CHECK

playdate_video :: struct {
    loadVideo:          (path: *u8) -> *LCDVideoPlayer #c_call;
    setContext:         (p: *LCDVideoPlayer, _context: *LCDBitmap) -> int #c_call;
    userScreenContext:  (p: *LCDVideoPlayer) #c_call;
    renderFrame:        (p: *LCDVideoPlayer, n: int) -> int #c_call;
    getError:           (p: *LCDVideoPlayer) -> *u8 #c_call;
    getInfo:            (p: *LCDVideoPlayer, outWidth: *int, outHeight: *int, outFrameRate: *float, outFrameCount: *int, outCurrentFrame: *int) #c_call;
    getContext:         (p: *LCDVideoPlayer) -> *LCDBitmap #c_call;
}

playdate_graphics :: struct {
    video:                  *playdate_video;

    clear:                  (color: LCDColor) #c_call;
    setBackgroundColor:     (color: LCDSolidColor) #c_call;
    setStencil:             (stencil: *LCDBitmap) #c_call;
    setDrawMode:            (mode: LCDBitmapDrawMode) #c_call;
    setDrawOffset:          (dx: int, dy: int) #c_call;
    setClipRect:            (x: int, y: int, width: int, height: int) #c_call;
    clearClipRect:          () #c_call;
    setLineCapStyle:        (endCapStyle: LCDLineCapStyle) #c_call;
    setFont:                (font: *LCDFont) #c_call;
    setTextTracking:        (tracking: int) #c_call;
    pushContext:            (target: *LCDBitmap) #c_call;
    popContext:             () #c_call;

    drawBitmap:             (bitmap: *LCDBitmap, x: int, y: int, flip: LCDBitmapFlip) #c_call;
    tileBitmap:             (bitmap: *LCDBitmap, x: int, y: int, width: int, height: int, flip: LCDBitmapFlip) #c_call;
    drawLine:               (x1: int, y1: int, x2: int, y2: int, width: int, color: LCDColor) #c_call;
    fillTriangle:           (x1: int, y1: int, x2: int, y2: int, x3: int, y3: int, color: LCDColor) #c_call;
    drawRect:               (x: int, y: int, width: int, height: int, color: LCDColor) #c_call;
    fillRect:               (x: int, y: int, width: int, height: int, color: LCDColor) #c_call;
    drawEllipse:            (x: int, y: int, width: int, height: int, lineWidth: int, startAngle: float, endAngle: float, color: LCDColor) #c_call;
    fillEllipse:            (x: int, y: int, width: int, height: int, startAngle: float, endAngle: float, color: LCDColor) #c_call;
    drawScaledBitmap:       (bitmap: *LCDBitmap, x: int, y: int, xscale: float, yscale: float) #c_call;
    drawText:               (text: *void, len: size_t, encoding: PDStringEncoding, x: int, y: int) -> int #c_call;

    newBitmap:              (width: int, height: int, bgcolor: LCDColor) -> *LCDBitmap #c_call;
    freeBitmap:             (bitmap: *LCDBitmap) #c_call;
    loadBitmap:             (path: *u8, outerr: **u8) -> *LCDBitmap #c_call;
    copyBitmap:             (bitmap: *LCDBitmap) -> *LCDBitmap #c_call;
    loadIntoBitmap:         (path: *u8, bitmap: *LCDBitmap, outerr: **u8) #c_call;
    getBitmapData:          (bitmap: *LCDBitmap, width: *int, height: *int, rowbytes: *int, hasmask: *int, data: **uint8_t) #c_call;
    clearBitmap:            (bitmap: *LCDBitmap, bgcolor: LCDColor) #c_call;

    loadFont:               (path: *u8, outerr: **u8) -> *LCDFont #c_call;
    getFontPage:            (font: *LCDFont, c: uint32_t) -> *LCDFontPage #c_call;
    getPageGlyph:           (page: *LCDFontPage, c: uint32_t, bitmap: **LCDBitmap, advance: *int) -> *LCDFontGlyph #c_call;
    getGlyphKerning:        (glyph: *LCDFontGlyph, glyphcode: uint32_t, nextcode: uint32_t) -> int #c_call;
    getTextWidth:           (font: *LCDFont, text: *void, len: size_t, encoding: PDStringEncoding, tracking: int) -> int #c_call;

    getFrame:               () -> *uint8_t #c_call;
    getDisplayFrame:        () -> *uint8_t #c_call;
    getDebugBitmap:         () -> *LCDBitmap #c_call;
    copyFrameBufferBitmap:  () -> *LCDBitmap #c_call;
    markUpdatedRows:        (start: int, end: int) #c_call;
    display:                () #c_call;

    setColorToPattern:      (color: *LCDColor, bitmap: *LCDBitmap, x: int, y: int) #c_call;
    checkMaskCollision:     (bitmap1: *LCDBitmap, x1: int, y1: int, flip1: LCDBitmapFlip, bitmap2: *LCDBitmap, x2: int, y2: int, flip2: LCDBitmapFlip, rect: LCDRect) -> int #c_call;

    setScreenClipRect:      (x: int, y: int, width: int, height: int) #c_call;

    fillPolygon:            (nPoints: int, coords: *int, color: LCDColor, fillrule: LCDPolygonFillRule) #c_call;
    getFontHeight:          (font: *LCDFont) -> uint8_t #c_call;

    getDisplayBufferBitmap: () -> *LCDBitmap #c_call;
    drawRotatedBitmap:      (bitmap: *LCDBitmap, x: int, y: int, rotation: float, centerx: float, centery: float, xscale: float, yscale: float) #c_call;
    setTextLeading:         (lineHeightAdjustment: int) #c_call;

    setBitmapMask:          (bitmap: *LCDBitmap, mask: *LCDBitmap) -> int #c_call;
    getBitmapMask:          (bitmap: *LCDBitmap) -> *LCDBitmap #c_call;

    setStencilImage:        (stencil: *LCDBitmap, tile: int) #c_call;
}


// SPRITE //////////////////////////////////////////////////////////////////////
SpriteCollisionResponseType :: enum {
    SLIDE;      //kCollisionTypeSlide
    FREEZE;     //kCollisionTypeFreeze
    OVERLAP;    //kCollisionTypeOverlap
    BOUNCE;     //kCollisionTypeBounce
}

PDRect :: struct { x, y, width, height: float; }

PDRectMake :: inline (x: float, y: float, width: float, height: float) -> PDRect { return .{ x, y, width, height }; } //TODO: remove?

CollisionPoint :: struct { x, y: float; }

CollisionVector :: struct { x, y: int; }

SpriteCollisionInfo :: struct {
    sprite:         *LCDSprite;
    other:          *LCDSprite;
    responseType:   SpriteCollisionResponseType;
    overlaps:       uint8_t;
    ti:             float;
    move:           CollisionPoint;
    normal:         CollisionVector;
    touch:          CollisionPoint;
    spriteRect:     PDRect;
    otherRect:      PDRect;
}

SpriteQueryInfo :: struct {
    sprite:     *LCDSprite;
    ti1:        float;
    ti2:        float;
    entryPoint: CollisionPoint;
    exitPoint:  CollisionPoint;
}

LCDSprite       :: #type void; //TODO: CHECK
CWCollisionInfo :: #type void; //TODO: CHECK
CWItemInfo      :: #type void; //TODO: CHECK

LCDSpriteDrawFunction           :: #type (sprite: *LCDSprite, bounds: PDRect, drawrect: PDRect) #c_call;
LCDSpriteUpdateFunction         :: #type (sprite: *LCDSprite) #c_call;
LCDSpriteCollisionFilterProc    :: #type (sprite: *LCDSprite, other: *LCDSprite) -> SpriteCollisionResponseType #c_call;

playdate_sprite :: struct {
    setAlwaysRedraw:                (flag: int) #c_call;
    addDirtyRect:                   (dirtyRect: LCDRect) #c_call;
    drawSprites:                    () #c_call;
    updateAndDrawSprites:           () #c_call;

    newSprite:                      () -> *LCDSprite #c_call;
    freeSprite:                     (sprite: *LCDSprite) #c_call;
    copy:                           (sprite: *LCDSprite) -> *LCDSprite #c_call;

    addSprite:                      (sprite: *LCDSprite) #c_call;
    removeSprite:                   (sprite: *LCDSprite) #c_call;
    removeSprites:                  (sprites: **LCDSprite, count: int) #c_call;
    removeAllSprites:               () #c_call;
    getSpriteCount:                 () -> int #c_call;

    setBounds:                      (sprite: *LCDSprite, bounds: PDRect) #c_call;
    getBounds:                      (sprite: *LCDSprite) -> PDRect #c_call;
    moveTo:                         (sprite: *LCDSprite, x: float, y: float) #c_call;
    moveBy:                         (sprite: *LCDSprite, dx: float, dy: float) #c_call;

    setImage:                       (sprite: *LCDSprite, image: *LCDBitmap, flip: LCDBitmapFlip) #c_call;
    getImage:                       (sprite: *LCDSprite) -> *LCDBitmap #c_call;
    setSize:                        (sprite: *LCDSprite, width: float, height: float) #c_call;
    setZIndex:                      (sprite: *LCDSprite, zIndex: int16_t) #c_call;
    getZIndex:                      (sprite: *LCDSprite) -> int16_t #c_call;

    setDrawMode:                    (sprite: *LCDSprite, mode: LCDBitmapDrawMode) #c_call;
    setImageFlip:                   (sprite: *LCDSprite, flip: LCDBitmapFlip) #c_call;
    getImageFlip:                   (sprite: *LCDSprite) -> LCDBitmapFlip #c_call;
    setStencil:                     (sprite: *LCDSprite, stencil: *LCDBitmap) #c_call;

    setClipRect:                    (sprite: *LCDSprite, clipRect: LCDRect) #c_call;
    clearClipRect:                  (sprite: *LCDSprite) #c_call;
    setClipRectsInRange:            (clipRect: LCDRect, startZ: int, endZ: int) #c_call;
    clearClipRectsInRange:          (startZ: int, endZ: int) #c_call;

    setUpdatesEnabled:              (sprite: *LCDSprite, flag: int) #c_call;
    updatesEnabled:                 (sprite: *LCDSprite) -> int #c_call;
    setCollisionsEnabled:           (sprite: *LCDSprite, flag: int) #c_call;
    collisionsEnabled:              (sprite: *LCDSprite) -> int #c_call;
    setVisible:                     (sprite: *LCDSprite, flag: int) #c_call;
    isVisible:                      (sprite: *LCDSprite) -> int #c_call;
    setOpaque:                      (sprite: *LCDSprite, flag: int) #c_call;
    markDirty:                      (sprite: *LCDSprite) #c_call;

    setTag:                         (sprite: *LCDSprite, tag: uint8_t) #c_call;
    getTag:                         (sprite: *LCDSprite) -> uint8_t #c_call;

    setIgnoreDrawOffset:            (sprite: *LCDSprite, flag: int) #c_call;

    setUpdateFunction:              (sprite: *LCDSprite, func: LCDSpriteUpdateFunction) #c_call;
    setDrawFunction:                (sprite: *LCDSprite, func: LCDSpriteDrawFunction) #c_call;

    getPosition:                    (sprite: *LCDSprite, x: *float, y: *float) #c_call;

    resetCollisionWorld:            () #c_call;

    setCollideRect:                 (sprite: *LCDSprite, collideRect: PDRect) #c_call;
    getCollideRect:                 (sprite: *LCDSprite) -> PDRect #c_call;
    clearCollideRect:               (sprite: *LCDSprite) #c_call;

    setCollisionResponseFunction:   (sprite: *LCDSprite, func: LCDSpriteCollisionFilterProc) #c_call;
    checkCollisions:                (sprite: *LCDSprite, goalX: float, goalY: float, actualX: *float, actualY: *float, len: *int) -> *SpriteCollisionInfo #c_call;
    moveWithCollisions:             (sprite: *LCDSprite, goalX: float, goalY: float, actualX: *float, actualY: *float, len: *int) -> *SpriteCollisionInfo #c_call;
    querySpritesAtPoint:            (x: float, y: float, len: *int) -> **LCDSprite #c_call;
    querySpritesInRect:             (x: float, y: float, width: float, height: float, len: *int) -> **LCDSprite #c_call;
    querySpritesAlongLine:          (x1: float, y1: float, x2: float, y2: float, len: *int) -> **LCDSprite #c_call;
    querySpriteInfoAlongLine:       (x1: float, y1: float, x2: float, y2: float, len: *int) -> *SpriteQueryInfo #c_call;
    overlappingSprites:             (sprite: *LCDSprite, len: *int) -> **LCDSprite #c_call;
    allOverlappingSprites:          (len: *int) -> **LCDSprite #c_call;

    setStencilPattern:              (sprite: *LCDSprite, pattern: *uint8_t) #c_call; // pattern is an array of 8
    clearStencil:                   (sprite: *LCDSprite) #c_call;

    setUserdata:                    (sprite: *LCDSprite, userdata: *void) #c_call;
    getUserdata:                    (sprite: *LCDSprite) -> *void #c_call;

    setStencilImage:                (sprite: *LCDSprite, stencil: *LCDBitmap, tile: int) #c_call;
}


// DISPLAY /////////////////////////////////////////////////////////////////////
playdate_display :: struct {
    getWidth:       () -> int #c_call;
    getHeight:      () -> int #c_call;

    setRefreshRate: (rate: float) #c_call;

    setInverted:    (flag: int) #c_call;
    setScale:       (s: u32) #c_call;
    setMosaic:      (x: u32, y: u32) #c_call;
    setFlipped:     (x: int, y: int) #c_call;
    setOffset:      (x: int, y: int) #c_call;
}


// SOUND ///////////////////////////////////////////////////////////////////////
AUDIO_FRAMES_PER_CYCLE :: 512;

SoundFormat :: enum uint32_t {
    EIGHT_BIT_MONO      :: 0; //kSound8bitMono
    EIGHT_BIT_STEREO    :: 1; //kSound8bitStereo
    SIXTEEN_BIT_MONO    :: 2; //kSound16bitMono
    SIXTEEN_BIT_STEREO  :: 3; //kSound16bitStereo
    ADPC_MONO           :: 4; //kSoundADPCMono
    ADPC_STEREO         :: 5; //kSoundADPCStereo
}

SoundFormatIsStereo         :: inline (fmt: SoundFormat) -> bool { return fmt&1 == 1; }
SoundFormatIs16bit          :: inline (fmt: SoundFormat) -> bool { return fmt>=SoundFormat.SIXTEEN_BIT_MONO; }
SoundFormat_bytesPerFrame   :: inline (fmt: SoundFormat) -> uint32_t {
    return cast(uint32_t) (ifx SoundFormatIsStereo(fmt) then 2 else 1) * cast(uint32_t) (ifx SoundFormatIs16bit(fmt) then 2 else 1);
}

MIDINote    :: #type float;
NOTE_C4     :: 60;

//pd_noteToFrequency //TODO
//pd_frequencyToNote //TODO

SoundSource     :: #type void; //TODO: CHECK
sndCallbackProc :: #type (c: *SoundSource) #c_call;

playdate_sound_source :: struct {
    setVolume:          (c: *SoundSource, lvol: float, rvol: float) #c_call;
    getVolume:          (c: *SoundSource, lvol: *float, rvol: *float) #c_call;
    isPlaying:          (c: *SoundSource) -> int #c_call;
    setFinishCallback:  (c: *SoundSource, callback: sndCallbackProc) #c_call;
}

FilePlayer :: #type void; //TODO: CHECK

playdate_sound_fileplayer :: struct {
    newPlayer:          () -> *FilePlayer #c_call;
    freePlayer:         (player: *FilePlayer) #c_call;
    loadIntoPlayer:     (player: *FilePlayer, path: *u8) -> int #c_call;
    setBufferLength:    (player: *FilePlayer, bufferLen: float) #c_call;
    play:               (player: *FilePlayer, repeat: int) -> int #c_call;
    isPlaying:          (player: *FilePlayer) -> int #c_call;
    pause:              (player: *FilePlayer) #c_call;
    stop:               (player: *FilePlayer) #c_call;
    setVolume:          (player: *FilePlayer, left: float, right: float) #c_call;
    getVolume:          (player: *FilePlayer, left: *float, right: *float) #c_call;
    getLength:          (player: *FilePlayer) -> float #c_call;
    setOffset:          (player: *FilePlayer, offset: float) #c_call;
    setRate:            (player: *FilePlayer, rate: float) #c_call;
    setLoopRange:       (player: *FilePlayer, start: float, end: float) #c_call;
    didUnderrun:        (player: *FilePlayer) -> int #c_call;
    setFinishCallback:  (player: *FilePlayer, callback: sndCallbackProc) #c_call;
    setLoopCallback:    (player: *FilePlayer, callback: sndCallbackProc) #c_call;
    getOffset:          (player: *FilePlayer) -> float #c_call;
    getRate:            (player: *FilePlayer) -> float #c_call;
    setStopOnUnderrun:  (player: *FilePlayer, flag: int) #c_call;
    fadeVolume:         (player: *FilePlayer, left: float, right: float, len: int32_t, finishCallback: sndCallbackProc) #c_call;
    setMP3StreamSource: (player: *FilePlayer, dataSource: (data: *uint8_t, bytes: int, userdata: *void) -> int, userdata: *void, bufferLen: float) #c_call;
}

AudioSample     :: #type void; //TODO: CHECK
SamplePlayer    :: #type void; //TODO: CHECK

playdate_sound_sample :: struct {
    newSampleBuffer:    (byteCount: int) -> *AudioSample #c_call;
    loadIntoSample:     (sample: *AudioSample, path: *u8) -> int #c_call;
    load:               (path: *u8) -> *AudioSample #c_call;
    newSampleFromData:  (data: *uint8_t, format: SoundFormat, sampleRate: uint32_t, byteCount: int) -> *AudioSample #c_call;
    getData:            (sample: *AudioSample, data: **uint8_t, format: *SoundFormat, sampleRate: *uint32_t, byteLength: *uint32_t) #c_call;
    freeSample:         (sample: *AudioSample) #c_call;
    getLength:          (sample: *AudioSample) -> float #c_call;
}

playdate_sound_sampleplayer :: struct {
    newPlayer:          () -> *SamplePlayer #c_call;
    freePlayer:         (player: *SamplePlayer) #c_call;
    setSample:          (player: *SamplePlayer, sample: *AudioSample) #c_call;
    play:               (player: *SamplePlayer, repeat: int, rate: float) -> int #c_call;
    isPlaying:          (player: *SamplePlayer) -> int #c_call;
    stop:               (player: *SamplePlayer) #c_call;
    setVolume:          (player: *SamplePlayer, left: float, right: float) #c_call;
    getVolume:          (player: *SamplePlayer, left: *float, right: *float) #c_call;
    getLength:          (player: *SamplePlayer) -> float #c_call;
    setOffset:          (player: *SamplePlayer, offset: float) #c_call;
    setRate:            (player: *SamplePlayer, rate: float) #c_call;
    setPlayRange:       (player: *SamplePlayer, start: int, end: int) #c_call;
    setFinishCallback:  (player: *SamplePlayer, callback: sndCallbackProc) #c_call;
    setLoopCallback:    (player: *SamplePlayer, callback: sndCallbackProc) #c_call;
    getOffset:          (player: *SamplePlayer) -> float #c_call;
    getRate:            (player: *SamplePlayer) -> float #c_call;
    setPaused:          (player: *SamplePlayer, flag: int) #c_call;
}

PDSynthSignalValue  :: #type void; //TODO: CHECK
PDSynthSignal       :: #type void; //TODO: CHECK

signalStepFunc      :: #type (userdata: *void, ioframes: *int, ifval: *float) -> float #c_call;
signalNoteOnFunc    :: #type (userdata: *void, note: MIDINote, vel: float, len: float) #c_call;
signalNoteOffFunc   :: #type (userdata: *void, stopped: int, offset: int) #c_call;
signalDeallocFunc   :: #type (userdata: *void) #c_call;

playdate_sound_signal :: struct {
    newSignal:      (step: signalStepFunc, noteOn: signalNoteOnFunc, dealloc: signalDeallocFunc, userdata: *void) -> *PDSynthSignal #c_call;
    freeSignal:     (signal: *PDSynthSignal) #c_call;
    getValue:       (signal: *PDSynthSignal) -> float #c_call;
    setValueScale:  (signal: *PDSynthSignal, scale: float) #c_call;
    setValueOffset: (signal: *PDSynthSignal, offset: float) #c_call;
}

LFOType :: enum {
    SQUARE;             // kLFOTypeSquare
    TRIANGLE;           // kLFOTypeTriangle
    SINE;               // kLFOTypeSine
    SAMPLE_AND_HOLD;    // kLFOTypeSampleAndHold
    SAWTOOTH_UP;        // kLFOTypeSawtoothUp
    SAWTOOTH_DOWN;      // kLFOTypeSawtoothDown
    ARPEGGIATOR;        // kLFOTypeArpeggiator
    FUNCTION;           // kLFOTypeFunction
}

PDSynthLFO :: #type void; // ???

playdate_sound_lfo :: struct {
    newLFO:             (type: LFOType) -> *PDSynthLFO #c_call;
    freeLFO:            (lfo: *PDSynthLFO) #c_call;
    setType:            (lfo: *PDSynthLFO, type: LFOType) #c_call;
    setRate:            (lfo: *PDSynthLFO, rate: float) #c_call;
    setPhase:           (lfo: *PDSynthLFO, phase: float) #c_call;
    setCenter:          (lfo: *PDSynthLFO, center: float) #c_call;
    setDepth:           (lfo: *PDSynthLFO, depth: float) #c_call;
    setArpeggiation:    (lfo: *PDSynthLFO, nSteps: int, steps: *float) #c_call;
    setFunction:        (lfo: *PDSynthLFO, lfoFunc: (lfo: *PDSynthLFO, userdata: *void) -> float, userdata: *void, interpolate: int) #c_call;
    setDelay:           (lfo: *PDSynthLFO, holdoff: float, ramptime: float) #c_call;
    setRetrigger:       (lfo: *PDSynthLFO, flag: int) #c_call;

    getValue:           (lfo: *PDSynthLFO) -> float #c_call;

    setGlobal:          (lfo: *PDSynthLFO, global: int) #c_call;
}

SoundWaveform :: enum {
    SQUARE;     // kWaveformSquare
    TRIANGLE;   // kWaveformTriangle
    SINE;       // kWaveformSine
    NOISE;      // kWaveformNoise
    SAWTOOTH;   // kWaveformSawtooth
    PO_PHASE;   // kWaveformPOPhase
    PO_DIGITAL; // kWaveformPODigital
    PO_VOSIM;   // kWaveformPOVosim
}

synthRenderFunc         :: #type (userdata: *void, left: *int32_t, right: *int32_t, nsamples: int, rate: uint32_t, drate: int32_t) -> int #c_call;

synthNoteOnFunc         :: #type (userdata: *void, note: MIDINote, velocity: float, len: float) #c_call;
synthNoteReleaseFunc    :: #type (userdata: *void, stop: int) #c_call;
synthSetParameterFunc   :: #type (userdata: *void, parameter: int, value: float) -> int #c_call;
synthDeallocFunc        :: #type (userdata: *void) #c_call;

PDSynth :: #type void; // ???

playdate_sound_synth :: struct {
    newSynth:               () -> *PDSynth #c_call;
    freeSynth:              (synth: *PDSynth) #c_call;

    setWaveform:            (synth: *PDSynth, wave: SoundWaveform) #c_call;
    setGenerator:           (synth: *PDSynth, stereo: int, render: synthRenderFunc, noteOn: synthNoteOnFunc, release: synthNoteReleaseFunc, setparam: synthSetParameterFunc, dealloc: synthDeallocFunc, userdata: *void) #c_call;
    setSample:              (synth: *PDSynth, sample: *AudioSample, sustainStart: uint32_t, sustainEnd: uint32_t) #c_call;

    setAttackTime:          (synth: *PDSynth, attack: float) #c_call;
    setDecayTime:           (synth: *PDSynth, decay: float) #c_call;
    setSustainLevel:        (synth: *PDSynth, sustain: float) #c_call;
    setReleaseTime:         (synth: *PDSynth, release: float) #c_call;

    setTranspose:           (synth: *PDSynth, halfSteps: float) #c_call;

    setFrequencyModulator:  (synth: *PDSynth, mod: *PDSynthSignalValue) #c_call;
    getFrequencyModulator:  (synth: *PDSynth) -> *PDSynthSignalValue #c_call;
    setAmplitudeModulator:  (synth: *PDSynth, mod: *PDSynthSignalValue) #c_call;
    getAmplitudeModulator:  (synth: *PDSynth) -> *PDSynthSignalValue #c_call;

    getParameterCount:      (synth: *PDSynth) -> int #c_call;
    setParameter:           (synth: *PDSynth, parameter: int, value: float) -> int #c_call;
    setParameterModulator:  (synth: *PDSynth, parameter: int, mod: *PDSynthSignalValue) #c_call;
    getParameterModulator:  (synth: *PDSynth, parameter: int) -> *PDSynthSignalValue #c_call;

    playNote:               (synth: *PDSynth, freq: float, vel: float, len: float, when: uint32_t) #c_call;
    playMIDINote:           (synth: *PDSynth, note: MIDINote, vel: float, len: float, when: uint32_t) #c_call;
    noteOff:                (synth: *PDSynth, when: uint32_t) #c_call;
    stop:                   (synth: *PDSynth) #c_call;

    setVolume:              (synth: *PDSynth, left: float, right: float) #c_call;
    getVolume:              (synth: *PDSynth, left: *float, right: *float) #c_call;

    isPlaying:              (synth: *PDSynth) -> int #c_call;
}

//
//TODO
//

playdate_sound :: struct {
    //TODO
}


// LUA /////////////////////////////////////////////////////////////////////////
lua_State :: #type *void;
lua_CFunction :: #type (L: *lua_State) -> int;

luaL_Val :: struct {
    name: *u8;
    type: enum { kInt; kFloat; kStr; }
    v: union {
        intval: u32;
        floatval: float;
        strval: *u8;
    }
}

LuaUDObject :: #type void; // ???

lua_reg :: struct {
    name: *u8;
    func: lua_CFunction;
}

LuaType :: enum {
    NIL;        //kTypeNil
    BOOL;       //kTypeBool
    INT;        //kTypeInt
    FLOAT;      //kTypeFloat
    STRING;     //kTypeString
    TABLE;      //kTypeTable
    FUNCTION;   //kTypeFunction
    THREAD;     //kTypeThread
    OBJECT;     //kTypeObject
}

playdate_lua :: struct {
    addFunction:                (f: lua_CFunction, name: *u8, outerr: **u8) -> int #c_call;
    registerClass:              (name: *u8, reg: *lua_reg, vals: *luaL_Val, isstatic: int, outerr: **u8) -> int #c_call;

    pushFunction:               (f: lua_CFunction) #c_call;
    indexMetatable:             () -> int #c_call;

    stop:                       () #c_call;
    start:                      () #c_call;

    getArgCount:                () -> int #c_call;
    getArgType:                 (pos: int, outClass: **u8) -> LuaType #c_call;

    argIsNil:                   (pos: int) -> int #c_call;
    getArgBool:                 (pos: int) -> int #c_call;
    getArgInt:                  (pos: int) -> int #c_call;
    getArgFloat:                (pos: int) -> float #c_call;
    getArgString:               (pos: int) -> *u8 #c_call;
    getArgBytes:                (pos: int, outlen: *size_t) -> *u8 #c_call;
    getArgObject:               (pos: int, type: *u8, outud: **LuaUDObject) -> *void #c_call;

    getBitmap:                  (pos: int) -> *LCDBitmap #c_call;
    getSprite:                  (pos: int) -> *LCDSprite #c_call;

    pushNil:                    () #c_call;
    pushBool:                   (val: int) #c_call;
    pushInt:                    (val: int) #c_call;
    pushFloat:                  (val: float) #c_call;
    pushString:                 (str: *u8) #c_call;
    pushBytes:                  (str: *u8, len: size_t) #c_call;
    pushBitmap:                 (bitmap: *LCDBitmap) #c_call;
    pushSprite:                 (sprite: *LCDSprite) #c_call;

    pushObject:                 (obj: *void, type: *u8, nValues: int) -> *LuaUDObject #c_call;
    retainObject:               (obj: *LuaUDObject) -> *LuaUDObject #c_call;
    releaseObject:              (obj: *LuaUDObject) #c_call;

    setObjectValue:             (obj: *LuaUDObject, slot: int) #c_call;
    getObjectValue:             (obj: *LuaUDObject, slot: int) -> int #c_call;

    callFunction_deprecated:    (name: *u8, nargs: int) #c_call;
    callFunction:               (name: *u8, nargs: int, outerr: **u8) -> int #c_call;
}


// JSON ////////////////////////////////////////////////////////////////////////
json_value_type :: enum u8 {
    NULL;       //kJSONNull
    TRUE;       //kJSONTrue
    FALSE;      //kJSONFalse
    INTEGER;    //kJSONInteger
    FLOAT;      //kJSONFloat
    STRING;     //kJSONString
    ARRAY;      //kJSONArray
    TABLE;      //kJSONTable
}

json_value :: struct {
    type: json_value_type;
    data: union {
        intval: int;
        floatval: float;
        stringval: *u8;
        arrayval: *void;
        tableval: *void;
    }
}

json_intValue :: inline (value: json_value) -> int {
    if value.type == {
        case .INTEGER;  return value.data.intval;
        case .FLOAT;    return cast(int) value.data.floatval;
        //case .STRING;   return //TODO
        case .TRUE;     return 1;
        case;           return 0;
    }
}

json_floatValue :: inline (value: json_value) -> float {
    if value.type == {
        case .INTEGER; return cast(float) value.data.intval;
        case .FLOAT;   return value.data.floatval;
        //case .STRING;   return //TODO
        case .TRUE;    return 1.0;
        case;          return 0.0;
    }
}

json_boolValue :: inline (value: json_value) -> int {
    //TODO
    return 0;
}

json_stringValue :: inline (value: json_value) -> *u8 {
    //TODO
    return null;
}

json_decoder :: struct {
    decodeError:                    (decoder: *json_decoder, error: *u8, linenum: int) #c_call;

    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type) #c_call;
    shouldDecodeTableValueForKey:   (decoder: *json_decoder, key: *u8) -> int #c_call;
    didDecodeTableValue:            (decoder: *json_decoder, key: *u8, value: json_value) #c_call;
    shouldDecodeArrayValueAtIndex:  (decoder: *json_decoder, pos: int) -> int #c_call;
    didDecodeArrayValue:            (decoder: *json_decoder, pos: int, value: json_value) #c_call;
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void #c_call;

    userdata: *void;
    returnString: int;
    path: *u8;
}

json_setTableDecode :: inline (
    decoder:                        *json_decoder,
    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type) #c_call,
    didDecodeTableValue:            (decoder: *json_decoder, key: *u8, value: json_value) #c_call,
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void #c_call
) {
    decoder.didDecodeTableValue = didDecodeTableValue;
    decoder.didDecodeArrayValue = null;
    decoder.willDecodeSublist   = willDecodeSublist;
    decoder.didDecodeSublist    = didDecodeSublist;
}

json_setArrayDecode :: inline (
    decoder:                        *json_decoder,
    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type) #c_call,
    didDecodeArrayValue:            (decoder: *json_decoder, pos: int, value: json_value) #c_call,
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void #c_call
) {
    decoder.didDecodeTableValue = null;
    decoder.didDecodeArrayValue = didDecodeArrayValue;
    decoder.willDecodeSublist   = willDecodeSublist;
    decoder.didDecodeSublist    = didDecodeSublist;
}

json_reader :: struct {
    read:       (userdata: *void, buf: *uint8_t, bufsize: int) -> int #c_call;
    userdata:   *void;
}

writeFunc :: #type (userdata: *void, str: *u8, len: int) #c_call;

json_encoder :: struct {
    writeStringFunc:    writeFunc;
    userdata:           *void;

    pretty:             int; //TODO: : 1
    startedTable:       int; //TODO: : 1
    startedArray:       int; //TODO: : 1
    depth:              int; //TODO: : 29

    startArray:         (encoder: *json_encoder) #c_call;
    addArrayMember:     (encoder: *json_encoder) #c_call;
    endArray:           (encoder: *json_encoder) #c_call;
    startTable:         (encoder: *json_encoder) #c_call;
    addTableMember:     (encoder: *json_encoder, name: *u8, len: int) #c_call;
    endTable:           (encoder: *json_encoder) #c_call;
    writeNull:          (encoder: *json_encoder) #c_call;
    writeFalse:         (encoder: *json_encoder) #c_call;
    writeTrue:          (encoder: *json_encoder) #c_call;
    writeInt:           (encoder: *json_encoder) #c_call;
    writeDouble:        (encoder: *json_encoder, num: float64) #c_call;
    writeString:        (encoder: *json_encoder, str: *u8, len: int) #c_call;
}

playdate_json :: struct {
    initEncoder:    (encoder: *json_encoder, write: *writeFunc, userdata: *void, pretty: int) #c_call;

    decode:         (functions: *json_decoder, reader: json_reader, outval: *json_value) -> int #c_call;
    decodeString:   (functions: *json_decoder, jsonString: *u8, outval: *json_value) -> int #c_call;
}


// SCOREBOARDS /////////////////////////////////////////////////////////////////
PDScore :: struct {
    rank:   uint32_t;
    value:  uint32_t;
    player: *u8;
}

PDScoresList :: struct {
    boardID:        *u8;
    count:          u32;
    lastUpdated:    uint32_t;
    playerIncluded: int;
    limit:          u32;
    scores:         *PDScore;
}

PDBoard :: struct {
    boardID:    *u8;
    name:       *u8;
}

PDBoardsList :: struct {
    count:          u32;
    lastUpdated:    uint32_t;
    boards:         *PDBoard;
}

AddScoreCallback        :: #type (score: *PDScore, errorMessage: *u8) #c_call;
PersonalBestCallback    :: #type (score: *PDScore, errorMessage: *u8) #c_call;
BoardsListCallback      :: #type (boards: *PDBoardsList, errorMessage: *u8) #c_call;
ScoresCallback          :: #type (scores: *PDScoresList, errorMessage: *u8) #c_call;

playdate_scoreboards :: struct {
    addScore:           (boardID: *u8, value: uint32_t, callback: AddScoreCallback) -> int #c_call;
    getPersonalBest:    (boardID: *u8, callback: PersonalBestCallback) -> int #c_call;
    freeScore:          (score: *PDScore) #c_call;

    getScoreboards:     (callback: BoardsListCallback) -> int #c_call;
    freeBoardsList:     (boardsList: *PDBoardsList) #c_call;

    getScores:          (boardID: *u8, callback: ScoresCallback) -> int #c_call;
    freeScoresList:     (scoresList: *PDScoresList) #c_call;
}


// CORE ////////////////////////////////////////////////////////////////////////
PlaydateAPI :: struct {
    system:         *playdate_sys;
    file:           *playdate_file;
    graphics:       *playdate_graphics;
    sprite:         *playdate_sprite;
    display:        *playdate_display;
    sound:          *playdate_sound;
    lua:            *playdate_lua;
    json:           *playdate_json;
    scoreboards:    *playdate_scoreboards;
}


PDSystemEvent :: enum {
    INIT;           //kEventInit
    INIT_LUA;       //kEventInitLua
    LOCK;           //kEventLock
    UNLOCK;         //kEventUnlock
    PAUSE;          //kEventPause
    RESUME;         //kEventResume
    TERMINATE;      //kEventTerminate
    KEY_PRESSED;    //kEventKeyPressed
    KEY_RELEASED;   //kEventKeyReleased
    LOW_POWER;      //kEventLowPower
}

//TODO: make sure these are all correct!!
uintptr_t   :: #type *u32;
uint32_t    :: #type u32;
uint8_t     :: #type u8;
int16_t     :: #type s16;
int32_t     :: #type s32;
size_t      :: #type u32;


//TODO: make sure this is what we want??
eventHandler :: #type (playdate: *PlaydateAPI, event: PDSystemEvent, arg: u32) -> int #c_call;
