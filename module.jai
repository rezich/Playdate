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
    ALL_PERIPHERALS :: 0xffff;                          //kAllPeripherals
}

PDCallbackFunction          :: #type (userdata: *void) -> int;
PDMenuItemCallbackFunction  :: #type (userdata: *void);

playdate_sys :: struct {
    realloc:                    (ptr: *void, size: size_t) -> *void;
    formatString:               (ret: **u8, fmt: *u8, __args: ..Any);
    logToConsole:               (fmt: *u8, __args: ..Any);
    error:                      (fmt: *u8, __args: ..Any);
    getLanguage:                () -> PDLanguage;
    getCurrentTimeMilliseconds: () -> u32;
    getSecondsSinceEpoch:       (milliseconds: *u32) -> u32;
    drawFPS:                    (x: int, y: int);

    setUpdateCallback:          (update: *PDCallbackFunction, userdata: *void);
    getButtonState:             (current: *PDButtons, pushed: *PDButtons, released: *PDButtons);
    setPeripheralsEnabled:      (mask: PDPeripherals);
    getAccelerometer:           (outx: *float, outy: *float, outz: *float);

    getCrankChange:             () -> float;
    getCrankAngle:              () -> float;
    isCrankDocked:              () -> int;
    setCrankSoundsDisabled:     (flag: int) -> int;

    getFlipped:                 () -> int;
    setAutoLockDisabled:        (disable: int);

    setMenuImage:               (bitmap: *LCDBitmap, xOffset: int);
    addMenuItem:                (title: *u8, callback: *PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem;
    addCheckmarkMenuItem:       (title: *u8, callback: *PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem;
    addOptionsMenuItem:         (title: *u8, optionTitles: **u8, optionsCount: int, callback: *PDMenuItemCallbackFunction, userdata: *void) -> *PDMenuItem;
    removeAllMenuItems:         ();
    removeMenuItem:             (menuItem: *PDMenuItem);
    getMenuItemValue:           (menuItem: *PDMenuItem) -> int;
    setMenuItemValue:           (menuItem: *PDMenuItem, value: int);
    getMenuItemTitle:           (menuItem: *PDMenuItem) -> *u8;
    setMenuItemTitle:           (menuItem: *PDMenuItem, title: *u8);
    getMenuItemUserdata:        (menuItem: *PDMenuItem) -> *void;
    setMenuItemUserdata:        (menuItem: *PDMenuItem, userdata: *void);

    getReduceFlashing:          () -> int;

    getElapsedTime:             () -> float;
    resetElapsedTime:           ();

    getBatteryPercentage:       () -> float;
    getBatteryVoltage:          () -> float;
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
    geterr:     () -> *u8;
    listfiles:  (path: *u8, callback: (path: *u8, userdata: *void), userdata: *void) -> int;
    stat:       (path: *u8, stat: *FileStat) -> int;
    mkdir:      (path: *u8) -> int;
    unlink:     (name: *u8, recursive: int) -> int;
    rename:     (from: *u8, to: *u8) -> int;

    open:       (name: *u8, mode: FileOptions) -> *SDFile;
    close:      (file: *SDFile) -> int;
    read:       (file: *SDFile, buf: *void, len: u32) -> int;
    write:      (file: *SDFile, buf: *void, len: u32) -> int;
    flush:      (file: *SDFile) -> int;
    tell:       (file: *SDFile) -> int;
    seek:       (file: *SDFile, pos: int, whence: int) -> int;
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

LCDPolygonFillRule :: enum {
    NON_ZERO; //kPolygonFillNonZero
    EVEN_ODD; //kPolygonFillEvenOdd
}

LCDBitmap :: struct {}
LCDBitmapTable :: struct {}
LCDFont :: struct {}
LCDFontPage :: struct {}
LCDFontGlyph :: struct {}
LCDVideoPlayer :: struct {}

playdate_video :: struct {
    loadVideo:          (path: *u8) -> *LCDVideoPlayer;
    setContext:         (p: *LCDVideoPlayer, _context: *LCDBitmap) -> int;
    userScreenContext:  (p: *LCDVideoPlayer);
    renderFrame:        (p: *LCDVideoPlayer, n: int) -> int;
    getError:           (p: *LCDVideoPlayer) -> *u8;
    getInfo:            (p: *LCDVideoPlayer, outWidth: *int, outHeight: *int, outFrameRate: *float, outFrameCount: *int, outCurrentFrame: *int);
    getContext:         (p: *LCDVideoPlayer) -> *LCDBitmap;
}

playdate_graphics :: struct {
    video:                  *playdate_video;

    clear:                  (color: LCDColor);
    setBackgroundColor:     (color: LCDSolidColor);
    setStencil:             (stencil: *LCDBitmap);
    setDrawMode:            (mode: LCDBitmapDrawMode);
    setDrawOffset:          (dx: int, dy: int);
    setClipRect:            (x: int, y: int, width: int, height: int);
    clearClipRect:          ();
    setLineCapStyle:        (endCapStyle: LCDLineCapStyle);
    setFont:                (font: *LCDFont);
    setTextTracking:        (tracking: int);
    pushContext:            (target: *LCDBitmap);
    popContext:             ();

    drawBitmap:             (bitmap: *LCDBitmap, x: int, y: int, flip: LCDBitmapFlip);
    tileBitmap:             (bitmap: *LCDBitmap, x: int, y: int, width: int, height: int, flip: LCDBitmapFlip);
    drawLine:               (x1: int, y1: int, x2: int, y2: int, width: int, color: LCDColor);
    fillTriangle:           (x1: int, y1: int, x2: int, y2: int, x3: int, y3: int, color: LCDColor);
    drawRect:               (x: int, y: int, width: int, height: int, color: LCDColor);
    fillRect:               (x: int, y: int, width: int, height: int, color: LCDColor);
    drawEllipse:            (x: int, y: int, width: int, height: int, lineWidth: int, startAngle: float, endAngle: float, color: LCDColor);
    fillEllipse:            (x: int, y: int, width: int, height: int, startAngle: float, endAngle: float, color: LCDColor);
    drawScaledBitmap:       (bitmap: *LCDBitmap, x: int, y: int, xscale: float, yscale: float);
    drawText:               (text: *void, len: size_t, encoding: PDStringEncoding, x: int, y: int) -> int;

    newBitmap:              (width: int, height: int, bgcolor: LCDColor) -> *LCDBitmap;
    freeBitmap:             (bitmap: *LCDBitmap);
    loadBitmap:             (path: *u8, outerr: **u8) -> *LCDBitmap;
    copyBitmap:             (bitmap: *LCDBitmap) -> *LCDBitmap;
    loadIntoBitmap:         (path: *u8, bitmap: *LCDBitmap, outerr: **u8);
    getBitmapData:          (bitmap: *LCDBitmap, width: *int, height: *int, rowbytes: *int, hasmask: *int, data: **uint8_t);
    clearBitmap:            (bitmap: *LCDBitmap, bgcolor: LCDColor);

    loadFont:               (path: *u8, outerr: **u8) -> *LCDFont;
    getFontPage:            (font: *LCDFont, c: uint32_t) -> *LCDFontPage;
    getPageGlyph:           (page: *LCDFontPage, c: uint32_t, bitmap: **LCDBitmap, advance: *int) -> *LCDFontGlyph;
    getGlyphKerning:        (glyph: *LCDFontGlyph, glyphcode: uint32_t, nextcode: uint32_t) -> int;
    getTextWidth:           (font: *LCDFont, text: *void, len: size_t, encoding: PDStringEncoding, tracking: int) -> int;

    getFrame:               () -> *uint8_t;
    getDisplayFrame:        () -> *uint8_t;
    getDebugBitmap:         () -> *LCDBitmap;
    copyFrameBufferBitmap:  () -> *LCDBitmap;
    markUpdatedRows:        (start: int, end: int);
    display:                ();

    setColorToPattern:      (color: *LCDColor, bitmap: *LCDBitmap, x: int, y: int);
    checkMaskCollision:     (bitmap1: *LCDBitmap, x1: int, y1: int, flip1: LCDBitmapFlip, bitmap2: *LCDBitmap, x2: int, y2: int, flip2: LCDBitmapFlip, rect: LCDRect) -> int;

    setScreenClipRect:      (x: int, y: int, width: int, height: int);

    fillPolygon:            (nPoints: int, coords: *int, color: LCDColor, fillrule: LCDPolygonFillRule);
    getFontHeight:          (font: *LCDFont) -> uint8_t;

    getDisplayBufferBitmap: () -> *LCDBitmap;
    drawRotatedBitmap:      (bitmap: *LCDBitmap, x: int, y: int, rotation: float, centerx: float, centery: float, xscale: float, yscale: float);
    setTextLeading:         (lineHeightAdjustment: int);

    setBitmapMask:          (bitmap: *LCDBitmap, mask: *LCDBitmap) -> int;
    getBitmapMask:          (bitmap: *LCDBitmap) -> *LCDBitmap;

    setStencilImage:        (stencil: *LCDBitmap, tile: int);
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

LCDSpriteDrawFunction           :: #type (sprite: *LCDSprite, bounds: PDRect, drawrect: PDRect);
LCDSpriteUpdateFunction         :: #type (sprite: *LCDSprite);
LCDSpriteCollisionFilterProc    :: #type (sprite: *LCDSprite, other: *LCDSprite) -> SpriteCollisionResponseType;

playdate_sprite :: struct {
    setAlwaysRedraw:                (flag: int);
    addDirtyRect:                   (dirtyRect: LCDRect);
    drawSprites:                    ();
    updateAndDrawSprites:           ();

    newSprite:                      () -> *LCDSprite;
    freeSprite:                     (sprite: *LCDSprite);
    copy:                           (sprite: *LCDSprite) -> *LCDSprite;

    addSprite:                      (sprite: *LCDSprite);
    removeSprite:                   (sprite: *LCDSprite);
    removeSprites:                  (sprites: **LCDSprite, count: int);
    removeAllSprites:               ();
    getSpriteCount:                 () -> int;

    setBounds:                      (sprite: *LCDSprite, bounds: PDRect);
    getBounds:                      (sprite: *LCDSprite) -> PDRect;
    moveTo:                         (sprite: *LCDSprite, x: float, y: float);
    moveBy:                         (sprite: *LCDSprite, dx: float, dy: float);

    setImage:                       (sprite: *LCDSprite, image: *LCDBitmap, flip: LCDBitmapFlip);
    getImage:                       (sprite: *LCDSprite) -> *LCDBitmap;
    setSize:                        (sprite: *LCDSprite, width: float, height: float);
    setZIndex:                      (sprite: *LCDSprite, zIndex: int16_t);
    getZIndex:                      (sprite: *LCDSprite) -> int16_t;

    setDrawMode:                    (sprite: *LCDSprite, mode: LCDBitmapDrawMode);
    setImageFlip:                   (sprite: *LCDSprite, flip: LCDBitmapFlip);
    getImageFlip:                   (sprite: *LCDSprite) -> LCDBitmapFlip;
    setStencil:                     (sprite: *LCDSprite, stencil: *LCDBitmap);

    setClipRect:                    (sprite: *LCDSprite, clipRect: LCDRect);
    clearClipRect:                  (sprite: *LCDSprite);
    setClipRectsInRange:            (clipRect: LCDRect, startZ: int, endZ: int);
    clearClipRectsInRange:          (startZ: int, endZ: int);

    setUpdatesEnabled:              (sprite: *LCDSprite, flag: int);
    updatesEnabled:                 (sprite: *LCDSprite) -> int;
    setCollisionsEnabled:           (sprite: *LCDSprite, flag: int);
    collisionsEnabled:              (sprite: *LCDSprite) -> int;
    setVisible:                     (sprite: *LCDSprite, flag: int);
    isVisible:                      (sprite: *LCDSprite) -> int;
    setOpaque:                      (sprite: *LCDSprite, flag: int);
    markDirty:                      (sprite: *LCDSprite);

    setTag:                         (sprite: *LCDSprite, tag: uint8_t);
    getTag:                         (sprite: *LCDSprite) -> uint8_t;

    setIgnoreDrawOffset:            (sprite: *LCDSprite, flag: int);

    setUpdateFunction:              (sprite: *LCDSprite, func: *LCDSpriteUpdateFunction);
    setDrawFunction:                (sprite: *LCDSprite, func: *LCDSpriteDrawFunction);

    getPosition:                    (sprite: *LCDSprite, x: *float, y: *float);

    resetCollisionWorld:            ();

    setCollideRect:                 (sprite: *LCDSprite, collideRect: PDRect);
    getCollideRect:                 (sprite: *LCDSprite) -> PDRect;
    clearCollideRect:               (sprite: *LCDSprite);

    setCollisionResponseFunction:   (sprite: *LCDSprite, func: *LCDSpriteCollisionFilterProc);
    checkCollisions:                (sprite: *LCDSprite, goalX: float, goalY: float, actualX: *float, actualY: *float, len: *int) -> *SpriteCollisionInfo;
    moveWithCollisions:             (sprite: *LCDSprite, goalX: float, goalY: float, actualX: *float, actualY: *float, len: *int) -> *SpriteCollisionInfo;
    querySpritesAtPoint:            (x: float, y: float, len: *int) -> **LCDSprite;
    querySpritesInRect:             (x: float, y: float, width: float, height: float, len: *int) -> **LCDSprite;
    querySpritesAlongLine:          (x1: float, y1: float, x2: float, y2: float, len: *int) -> **LCDSprite;
    querySpriteInfoAlongLine:       (x1: float, y1: float, x2: float, y2: float, len: *int) -> *SpriteQueryInfo;
    overlappingSprites:             (sprite: *LCDSprite, len: *int) -> **LCDSprite;
    allOverlappingSprites:          (len: *int) -> **LCDSprite;

    setStencilPattern:              (sprite: *LCDSprite, pattern: [8] uint8_t);
    clearStencil:                   (sprite: *LCDSprite);

    setUserdata:                    (sprite: *LCDSprite, userdata: *void);
    getUserdata:                    (sprite: *LCDSprite) -> *void;

    setStencilImage:                (sprite: *LCDSprite, stencil: *LCDBitmap, tile: int);
}


// DISPLAY /////////////////////////////////////////////////////////////////////
playdate_display :: struct {
    getWidth:       () -> int;
    getHeight:      () -> int;

    setRefreshRate: (rate: float);

    setInverted:    (flag: int);
    setScale:       (s: u32);
    setMosaic:      (x: u32, y: u32);
    setFlipped:     (x: int, y: int);
    setOffset:      (x: int, y: int);
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
sndCallbackProc :: #type (c: *SoundSource);

playdate_sound_source :: struct {
    setVolume:          (c: *SoundSource, lvol: float, rvol: float);
    getVolume:          (c: *SoundSource, lvol: *float, rvol: *float);
    isPlaying:          (c: *SoundSource) -> int;
    setFinishCallback:  (c: *SoundSource, callback: sndCallbackProc);
}

FilePlayer :: #type void; //TODO: CHECK

playdate_sound_fileplayer :: struct {
    newPlayer:          () -> *FilePlayer;
    freePlayer:         (player: *FilePlayer);
    loadIntoPlayer:     (player: *FilePlayer, path: *u8) -> int;
    setBufferLength:    (player: *FilePlayer, bufferLen: float);
    play:               (player: *FilePlayer, repeat: int) -> int;
    isPlaying:          (player: *FilePlayer) -> int;
    pause:              (player: *FilePlayer);
    stop:               (player: *FilePlayer);
    setVolume:          (player: *FilePlayer, left: float, right: float);
    getVolume:          (player: *FilePlayer, left: *float, right: *float);
    getLength:          (player: *FilePlayer) -> float;
    setOffset:          (player: *FilePlayer, offset: float);
    setRate:            (player: *FilePlayer, rate: float);
    setLoopRange:       (player: *FilePlayer, start: float, end: float);
    didUnderrun:        (player: *FilePlayer) -> int;
    setFinishCallback:  (player: *FilePlayer, callback: sndCallbackProc);
    setLoopCallback:    (player: *FilePlayer, callback: sndCallbackProc);
    getOffset:          (player: *FilePlayer) -> float;
    getRate:            (player: *FilePlayer) -> float;
    setStopOnUnderrun:  (player: *FilePlayer, flag: int);
    fadeVolume:         (player: *FilePlayer, left: float, right: float, len: int32_t, finishCallback: sndCallbackProc);
    setMP3StreamSource: (player: *FilePlayer, dataSource: (data: *uint8_t, bytes: int, userdata: *void) -> int, userdata: *void, bufferLen: float);
}

AudioSample     :: #type void; //TODO: CHECK
SamplePlayer    :: #type void; //TODO: CHECK

playdate_sound_sample :: struct {
    newSampleBuffer:    (byteCount: int) -> *AudioSample;
    loadIntoSample:     (sample: *AudioSample, path: *u8) -> int;
    load:               (path: *u8) -> *AudioSample;
    newSampleFromData:  (data: *uint8_t, format: SoundFormat, sampleRate: uint32_t, byteCount: int) -> *AudioSample;
    getData:            (sample: *AudioSample, data: **uint8_t, format: *SoundFormat, sampleRate: *uint32_t, byteLength: *uint32_t);
    freeSample:         (sample: *AudioSample);
    getLength:          (sample: *AudioSample) -> float;
}

playdate_sound_sampleplayer :: struct {
    newPlayer:          () -> *SamplePlayer;
    freePlayer:         (player: *SamplePlayer);
    setSample:          (player: *SamplePlayer, sample: *AudioSample);
    play:               (player: *SamplePlayer, repeat: int, rate: float) -> int;
    isPlaying:          (player: *SamplePlayer) -> int;
    stop:               (player: *SamplePlayer);
    setVolume:          (player: *SamplePlayer, left: float, right: float);
    getVolume:          (player: *SamplePlayer, left: *float, right: *float);
    getLength:          (player: *SamplePlayer) -> float;
    setOffset:          (player: *SamplePlayer, offset: float);
    setRate:            (player: *SamplePlayer, rate: float);
    setPlayRange:       (player: *SamplePlayer, start: int, end: int);
    setFinishCallback:  (player: *SamplePlayer, callback: sndCallbackProc);
    setLoopCallback:    (player: *SamplePlayer, callback: sndCallbackProc);
    getOffset:          (player: *SamplePlayer) -> float;
    getRate:            (player: *SamplePlayer) -> float;
    setPaused:          (player: *SamplePlayer, flag: int);
}

PDSynthSignalValue  :: #type void; //TODO: CHECK
PDSynthSignal       :: #type void; //TODO: CHECK

signalStepFunc      :: #type (userdata: *void, ioframes: *int, ifval: *float) -> float;
signalNoteOnFunc    :: #type (userdata: *void, note: MIDINote, vel: float, len: float);
signalNoteOffFunc   :: #type (userdata: *void, stopped: int, offset: int);
signalDeallocFunc   :: #type (userdata: *void);

playdate_sound_signal :: struct {
    newSignal:      (step: signalStepFunc, noteOn: signalNoteOnFunc, dealloc: signalDeallocFunc, userdata: *void) -> *PDSynthSignal;
    freeSignal:     (signal: *PDSynthSignal);
    getValue:       (signal: *PDSynthSignal) -> float;
    setValueScale:  (signal: *PDSynthSignal, scale: float);
    setValueOffset: (signal: *PDSynthSignal, offset: float);
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
    newLFO:             (type: LFOType) -> *PDSynthLFO;
    freeLFO:            (lfo: *PDSynthLFO);
    setType:            (lfo: *PDSynthLFO, type: LFOType);
    setRate:            (lfo: *PDSynthLFO, rate: float);
    setPhase:           (lfo: *PDSynthLFO, phase: float);
    setCenter:          (lfo: *PDSynthLFO, center: float);
    setDepth:           (lfo: *PDSynthLFO, depth: float);
    setArpeggiation:    (lfo: *PDSynthLFO, nSteps: int, steps: *float);
    setFunction:        (lfo: *PDSynthLFO, lfoFunc: (lfo: *PDSynthLFO, userdata: *void) -> float, userdata: *void, interpolate: int);
    setDelay:           (lfo: *PDSynthLFO, holdoff: float, ramptime: float);
    setRetrigger:       (lfo: *PDSynthLFO, flag: int);

    getValue:           (lfo: *PDSynthLFO) -> float;

    setGlobal:          (lfo: *PDSynthLFO, global: int);
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

synthRenderFunc         :: #type (userdata: *void, left: *int32_t, right: *int32_t, nsamples: int, rate: uint32_t, drate: int32_t) -> int;

synthNoteOnFunc         :: #type (userdata: *void, note: MIDINote, velocity: float, len: float);
synthNoteReleaseFunc    :: #type (userdata: *void, stop: int);
synthSetParameterFunc   :: #type (userdata: *void, parameter: int, value: float) -> int;
synthDeallocFunc        :: #type (userdata: *void);

PDSynth :: #type void; // ???

playdate_sound_synth :: struct {
    newSynth:               () -> *PDSynth;
    freeSynth:              (synth: *PDSynth);

    setWaveform:            (synth: *PDSynth, wave: SoundWaveform);
    setGenerator:           (synth: *PDSynth, stereo: int, render: synthRenderFunc, noteOn: synthNoteOnFunc, release: synthNoteReleaseFunc, setparam: synthSetParameterFunc, dealloc: synthDeallocFunc, userdata: *void);
    setSample:              (synth: *PDSynth, sample: *AudioSample, sustainStart: uint32_t, sustainEnd: uint32_t);

    setAttackTime:          (synth: *PDSynth, attack: float);
    setDecayTime:           (synth: *PDSynth, decay: float);
    setSustainLevel:        (synth: *PDSynth, sustain: float);
    setReleaseTime:         (synth: *PDSynth, release: float);

    setTranspose:           (synth: *PDSynth, halfSteps: float);

    setFrequencyModulator:  (synth: *PDSynth, mod: *PDSynthSignalValue);
    getFrequencyModulator:  (synth: *PDSynth) -> *PDSynthSignalValue;
    setAmplitudeModulator:  (synth: *PDSynth, mod: *PDSynthSignalValue);
    getAmplitudeModulator:  (synth: *PDSynth) -> *PDSynthSignalValue;

    getParameterCount:      (synth: *PDSynth) -> int;
    setParameter:           (synth: *PDSynth, parameter: int, value: float) -> int;
    setParameterModulator:  (synth: *PDSynth, parameter: int, mod: *PDSynthSignalValue);
    getParameterModulator:  (synth: *PDSynth, parameter: int) -> *PDSynthSignalValue;

    playNote:               (synth: *PDSynth, freq: float, vel: float, len: float, when: uint32_t);
    playMIDINote:           (synth: *PDSynth, note: MIDINote, vel: float, len: float, when: uint32_t);
    noteOff:                (synth: *PDSynth, when: uint32_t);
    stop:                   (synth: *PDSynth);

    setVolume:              (synth: *PDSynth, left: float, right: float);
    getVolume:              (synth: *PDSynth, left: *float, right: *float);

    isPlaying:              (synth: *PDSynth) -> int;
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
    addFunction:                (f: lua_CFunction, name: *u8, outerr: **u8) -> int;
    registerClass:              (name: *u8, reg: *lua_reg, vals: *luaL_Val, isstatic: int, outerr: **u8) -> int;

    pushFunction:               (f: lua_CFunction);
    indexMetatable:             () -> int;

    stop:                       ();
    start:                      ();

    getArgCount:                () -> int;
    getArgType:                 (pos: int, outClass: **u8) -> LuaType;

    argIsNil:                   (pos: int) -> int;
    getArgBool:                 (pos: int) -> int;
    getArgInt:                  (pos: int) -> int;
    getArgFloat:                (pos: int) -> float;
    getArgString:               (pos: int) -> *u8;
    getArgBytes:                (pos: int, outlen: *size_t) -> *u8;
    getArgObject:               (pos: int, type: *u8, outud: **LuaUDObject) -> *void;

    getBitmap:                  (pos: int) -> *LCDBitmap;
    getSprite:                  (pos: int) -> *LCDSprite;

    pushNil:                    ();
    pushBool:                   (val: int);
    pushInt:                    (val: int);
    pushFloat:                  (val: float);
    pushString:                 (str: *u8);
    pushBytes:                  (str: *u8, len: size_t);
    pushBitmap:                 (bitmap: *LCDBitmap);
    pushSprite:                 (sprite: *LCDSprite);

    pushObject:                 (obj: *void, type: *u8, nValues: int) -> *LuaUDObject;
    retainObject:               (obj: *LuaUDObject) -> *LuaUDObject;
    releaseObject:              (obj: *LuaUDObject);

    setObjectValue:             (obj: *LuaUDObject, slot: int);
    getObjectValue:             (obj: *LuaUDObject, slot: int) -> int;

    callFunction_deprecated:    (name: *u8, nargs: int);
    callFunction:               (name: *u8, nargs: int, outerr: **u8) -> int;
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
    decodeError:                    (decoder: *json_decoder, error: *u8, linenum: int);

    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type);
    shouldDecodeTableValueForKey:   (decoder: *json_decoder, key: *u8) -> int;
    didDecodeTableValue:            (decoder: *json_decoder, key: *u8, value: json_value);
    shouldDecodeArrayValueAtIndex:  (decoder: *json_decoder, pos: int) -> int;
    didDecodeArrayValue:            (decoder: *json_decoder, pos: int, value: json_value);
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void;

    userdata: *void;
    returnString: int;
    path: *u8;
}

json_setTableDecode :: inline (
    decoder:                        *json_decoder,
    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type),
    didDecodeTableValue:            (decoder: *json_decoder, key: *u8, value: json_value),
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void
) {
    decoder.didDecodeTableValue = didDecodeTableValue;
    decoder.didDecodeArrayValue = null;
    decoder.willDecodeSublist   = willDecodeSublist;
    decoder.didDecodeSublist    = didDecodeSublist;
}

json_setArrayDecode :: inline (
    decoder:                        *json_decoder,
    willDecodeSublist:              (decoder: *json_decoder, name: *u8, type: json_value_type),
    didDecodeArrayValue:            (decoder: *json_decoder, pos: int, value: json_value),
    didDecodeSublist:               (decoder: *json_decoder, name: *u8, type: json_value_type) -> *void
) {
    decoder.didDecodeTableValue = null;
    decoder.didDecodeArrayValue = didDecodeArrayValue;
    decoder.willDecodeSublist   = willDecodeSublist;
    decoder.didDecodeSublist    = didDecodeSublist;
}

json_reader :: struct {
    read:       (userdata: *void, buf: *uint8_t, bufsize: int) -> int;
    userdata:   *void;
}

writeFunc :: #type (userdata: *void, str: *u8, len: int);

json_encoder :: struct {
    writeStringFunc:    *writeFunc;
    userdata:           *void;

    pretty:             int; //TODO: : 1
    startedTable:       int; //TODO: : 1
    startedArray:       int; //TODO: : 1
    depth:              int; //TODO: : 29

    startArray:         (encoder: *json_encoder);
    addArrayMember:     (encoder: *json_encoder);
    endArray:           (encoder: *json_encoder);
    startTable:         (encoder: *json_encoder);
    addTableMember:     (encoder: *json_encoder, name: *u8, len: int);
    endTable:           (encoder: *json_encoder);
    writeNull:          (encoder: *json_encoder);
    writeFalse:         (encoder: *json_encoder);
    writeTrue:          (encoder: *json_encoder);
    writeInt:           (encoder: *json_encoder);
    writeDouble:        (encoder: *json_encoder, num: float64);
    writeString:        (encoder: *json_encoder, str: *u8, len: int);
}

playdate_json :: struct {
    initEncoder:    (encoder: *json_encoder, write: *writeFunc, userdata: *void, pretty: int);

    decode:         (functions: *json_decoder, reader: json_reader, outval: *json_value) -> int;
    decodeString:   (functions: *json_decoder, jsonString: *u8, outval: *json_value) -> int;
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

AddScoreCallback        :: #type (score: *PDScore, errorMessage: *u8);
PersonalBestCallback    :: #type (score: *PDScore, errorMessage: *u8);
BoardsListCallback      :: #type (boards: *PDBoardsList, errorMessage: *u8);
ScoresCallback          :: #type (scores: *PDScoresList, errorMessage: *u8);

playdate_scoreboards :: struct {
    addScore:           (boardID: *u8, value: uint32_t, callback: AddScoreCallback) -> int;
    getPersonalBest:    (boardID: *u8, callback: PersonalBestCallback) -> int;
    freeScore:          (score: *PDScore);

    getScoreboards:     (callback: BoardsListCallback) -> int;
    freeBoardsList:     (boardsList: *PDBoardsList);

    getScores:          (boardID: *u8, callback: ScoresCallback) -> int;
    freeScoresList:     (scoresList: *PDScoresList);
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
eventHandler :: #type (playdate: *PlaydateAPI, event: PDSystemEvent, arg: u32) -> int;
