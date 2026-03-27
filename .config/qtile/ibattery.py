"""
iBattery widget courtesy of Fadi.
The pull request can be found here.
A widget that displays a nice battery icon using cairo
it is similar to the one in iOS 16.

Use:
    1. import it to your qtile config.py as follows:
    from ibattery import Battery as MyBattery
    2. add it to your widget list in your bar:
    MyBattery(),
requirements: psutil (used to gather info about the battery.)
optional: dbus-next (used to send notification.)
"""
from libqtile.widget import base
from libqtile.log_utils import logger
from libqtile.utils import send_notification
from libqtile import bar
import math
import cairocffi as cairo
import psutil

class Battery(base._Widget):
    """A widget to display a nice battery.
    requirements: psutil
    optional: dbus-next (used to send notification).
    """
    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        (
            "padding",
            2,
            "int. padding on either side of of the widget."
        ),
        (
            "foreground",
            "d5d5d5",
            "string. Battery color in normal mode."
        ),
        (
            "charging_fg",
            "02a724",
            "string. foreground color when battery is charging."
        ),
        (
            "update_interval",
            20,
            "int. time to wait until the widgets refreshes."
        ),
        (
            "low_foreground",
            "ff0000",
            "string. change color when battery is low."
        ),
        (
            "warn_below",
            10,
            "int. battery level to indicate battery is low."
        ),
        (
            "notify",
            False,
            "bool. send a notification when battery is low."
        ),
        (
            "notification_timeout",
            10,
            "int. time in seconds to display notification."
        ),
        (
            "size",
            (18, 35),
            "Size of the widget. takes a tuple: (height:int, width:int). "
        ),
        (
            "font_family",
            "sans",
            "string. font family for the numbers inside the battery icon."
        ),
        (
            "font_size",
            15,
            "int. font size of the numbers inside the battery."
        ),
        (
            "font_color",
            None,
            "string. font color"
        ),
        (
            "battery_border",
            False,
            "bool. add a border to the battery icon."
        ),
    ]

    def __init__(self, **config):
        base._Widget.__init__(self, bar.CALCULATED, **config)
        self.add_defaults(Battery.defaults)
        self.HEIGHT, self.BAR_WIDTH = self.size  # battery bar
        self.margin = 2
        self._has_notified = False
        self.timeout = int(self.notification_timeout * 1000)
        self._foreground = self.foreground if self.foreground else "d5d5d5"
        
    def calculate_length(self):
        if self.bar.horizontal:
            return self.padding * 2 + self.BAR_WIDTH + 7.5 + self.margin * 2
        else:
            return 0

    def update(self):
        # This is called by Qtile's update mechanism
        self.draw()

    def draw(self):
        if self.drawer is None:
            logger.warning("Drawer is None in battery widget")
            return
            
        try:
            percent, charging = self.get_bat()
            logger.info(f"DEBUG: Battery info - percent: {percent}, charging: {charging}")
            self.configure(percent, charging)
            
            # Clear the drawer with background color
            self.drawer.clear(self.background or self.bar.background)
            
            # Draw the battery
            self.draw_battery(percent, charging)
            
            # Finish drawing
            self.drawer.draw(offsetx=self.offsetx, offsety=self.offsety)
            logger.info("DEBUG: Battery widget drawn successfully")
        except Exception as e:
            logger.error(f"DEBUG: Error in draw method: {e}")
            logger.error(f"DEBUG: Error type: {type(e).__name__}")
            import traceback
            logger.error(f"DEBUG: Full traceback: {traceback.format_exc()}")

    def configure(self, percent, charging):
        if charging:
            self.current_fg = self.charging_fg
        elif percent < self.warn_below:
            self.current_fg = self.low_foreground
        else:
            self.current_fg = self._foreground

    def get_bat(self):
        try:
            # Try to get battery info from psutil
            battery = psutil.sensors_battery()
            if battery is None:
                logger.warning("No battery information available")
                return 0, False
            
            percent = int(battery.percent)
            charging = battery.power_plugged
            logger.info(f"DEBUG: Battery data - percent: {percent}, charging: {charging}")
            return percent, charging
        except Exception as e:
            logger.error(f"DEBUG: Error getting battery info: {e}")
            import traceback
            logger.error(f"DEBUG: Full traceback: {traceback.format_exc()}")
            return 0, False

    def _notify(self, percent):
        if not self._has_notified:
            send_notification(
                "LOW BATTERY",
                f"Battery at {percent}% remaining",
                urgent=True,
                timeout=self.timeout
            )
            self._has_notified = True

    def draw_battery(self, percent, charging):
        if self.drawer is None:
            logger.warning("Drawer is None in draw_battery")
            return
            
        try:
            # Get the drawing context
            ctx = self.drawer.ctx
            logger.info(f"DEBUG: Drawing battery with percent: {percent}")
            
            # Set up battery dimensions
            bar_width = self.BAR_WIDTH
            bar_height = self.HEIGHT
            margin = self.margin
            
            # Calculate positions for battery body
            x = margin
            y = (self.bar.height - bar_height) // 2
            
            logger.info(f"DEBUG: Battery position - x: {x}, y: {y}")
            
            # Draw battery outline with rounded corners
            ctx.set_source_rgb(*self.hex_to_rgb(self.current_fg))
            
            # Create rounded rectangle path for battery body
            radius = 4  # Rounded corner radius
            self.rounded_rectangle(ctx, x, y, bar_width + 2 * margin, bar_height, radius)
            ctx.set_line_width(1)
            ctx.stroke()
            
            # Draw battery tip (connector) with rounded corners
            tip_x = x + bar_width + 2 * margin
            tip_y = y + bar_height // 2 - 4
            tip_width = 4
            tip_height = 8
            
            ctx.rectangle(tip_x, tip_y, tip_width, tip_height)
            ctx.set_line_width(1)
            ctx.stroke()
            
            # Draw battery fill with rounded corners
            if percent > 0:
                # Calculate fill dimensions
                fill_width = int((percent / 100.0) * bar_width)
                fill_height = bar_height - 4
                
                # Position the fill inside the battery body with proper padding
                fill_x = x + 2
                fill_y = y + 2
                
                logger.info(f"DEBUG: Fill dimensions - width: {fill_width}, height: {fill_height}")
                
                # Create rounded rectangle for fill
                self.rounded_rectangle(ctx, fill_x, fill_y, fill_width, fill_height, radius-1)
                
                if charging:
                    # Use charging color for fill when charging
                    ctx.set_source_rgb(*self.hex_to_rgb("#02a724"))
                else:
                    # Use regular battery color for fill
                    ctx.set_source_rgb(*self.hex_to_rgb(self.current_fg))
                    
                ctx.fill_preserve()  # Fill and keep the path
                
                # Stroke the fill to make it visible (optional)
                ctx.set_source_rgb(*self.hex_to_rgb(self.current_fg))
                ctx.set_line_width(1)
                ctx.stroke()
            
            # Draw percentage text inside battery
            if percent > 0 and percent <= 100:
                try:
                    logger.info("DEBUG: Attempting to draw percentage text")
                    # Set up font for percentage text
                    ctx.select_font_face("Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
                    ctx.set_font_size(12)  # Explicit font size
                    ctx.set_source_rgb(*self.hex_to_rgb("#000000"))

                    # Create text extents to see if it works
                    text = str(percent)
                    logger.info(f"DEBUG: Text to draw: '{text}'")
                    
                    # Get text extents
                    xbearing, ybearing, width, height, xadvance, yadvance = ctx.text_extents(text)
                    logger.info(f"DEBUG: Text extents - width: {width}, height: {height}")
                    
                    # Position text in center of battery
                    text_x = x + (bar_width + 2 * margin) / 2 - width / 2
                    text_y = y + bar_height / 2 + height / 2
                    
                    logger.info(f"DEBUG: Text position - x: {text_x}, y: {text_y}")
                    
                    ctx.move_to(text_x, text_y)
                    ctx.show_text(text)
                    logger.info("DEBUG: Successfully drew percentage text")
                    
                except Exception as e:
                    logger.error(f"DEBUG: Error drawing text: {e}")
                    import traceback
                    logger.error(f"DEBUG: Text drawing traceback: {traceback.format_exc()}")
            else:
                logger.info("DEBUG: Skipping text drawing - percent is 0 or > 100")
                
        except Exception as e:
            logger.error(f"DEBUG: Error in draw_battery method: {e}")
            import traceback
            logger.error(f"DEBUG: Full traceback: {traceback.format_exc()}")

    def hex_to_rgb(self, hex_color):
        """Convert hex color to RGB tuple"""
        hex_color = hex_color.lstrip('#')
        if len(hex_color) == 3:
            # Handle shorthand like #fff
            hex_color = ''.join([c*2 for c in hex_color])
        try:
            return tuple(int(hex_color[i:i+2], 16)/255.0 for i in (0, 2, 4))
        except Exception as e:
            logger.error(f"DEBUG: Error converting hex {hex_color}: {e}")
            return (1.0, 1.0, 1.0)  # Default white

    def rounded_rectangle(self, ctx, x, y, width, height, radius):
        """Draw a rounded rectangle"""
        try:
            logger.info(f"DEBUG: Drawing rounded rectangle - x: {x}, y: {y}, w: {width}, h: {height}, r: {radius}")
            ctx.new_path()
            
            # Create the path
            ctx.arc(x + width - radius, y + radius, radius, -0.5 * math.pi, 0)
            ctx.arc(x + width - radius, y + height - radius, radius, 0, 0.5 * math.pi)
            ctx.arc(x + radius, y + height - radius, radius, 0.5 * math.pi, math.pi)
            ctx.arc(x + radius, y + radius, radius, math.pi, 1.5 * math.pi)
            ctx.close_path()
            
            logger.info("DEBUG: Rounded rectangle path created successfully")
        except Exception as e:
            logger.error(f"DEBUG: Error in rounded_rectangle: {e}")
            import traceback
            logger.error(f"DEBUG: Full traceback: {traceback.format_exc()}")

# Add this for testing purposes
if __name__ == "__main__":
    print("Battery widget module loaded successfully")
