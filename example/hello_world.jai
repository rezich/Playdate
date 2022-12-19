PD :: #import,dir "../../Playdate";

main :: () { } //TODO: remove

fontpath :: "/System/Fonts/Asheville-Sans-14-Bold.pft";
font: *PD.LCDFont;

eventHandler :: (pd: *PD.PlaydateAPI, event: PD.PDSystemEvent, arg: u32) -> int {
    if event == {
        case .INIT;
            err: *u8;
            pd.graphics.loadFont(fontpath, *err);
            pd.system.setUpdateCallback(update, pd);
    }
    return 0;
}

TEXT_WIDTH  :: 86;
TEXT_HEIGHT :: 16;


x   := (400-TEXT_WIDTH )/2;
y   := (240-TEXT_HEIGHT)/2;
dx  := 1;
dy  := 2;

update :: (userdata: *void) -> int #c_call {
    pd: *PD.PlaydateAPI = userdata;

    //pd.graphics.clear(.WHITE);
    pd.graphics.clear(xx 1);
    pd.graphics.setFont(font);

    the_message :: "Hello world!";
    pd.graphics.drawText(the_message.data, the_message.count, .ASCII, x, y);

    x += dx;
    y += dy;

    if x < 0 || x > PD.LCD_COLUMNS - TEXT_WIDTH    then dx = -dx;
    if y < 0 || y > PD.LCD_ROWS    - TEXT_HEIGHT   then dy = -dy;

    pd.system.drawFPS(0,0);

    return 1;
}
