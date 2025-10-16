-- Improved Lua code for Conky

require('cairo_xlib')
-- Color definitions
local colors = {
    trans1 = 0xff000d,
    black1 = 0x1A132F,
    red1 = 0xff000d,
    pink1 = 0xd81b60,
    purple1 = 0x8e24aa,
    deeppurple1 = 0x5e35b1,
    indigo1 = 0x3949ab,
    blue1 = 0x1e88e5,
    lightblue1 = 0x039be5,
    cyan1 = 0x00acc1,
    teal1 = 0x00897b,
    green1 = 0x43a047,
    lightgreen1 = 0x3ad80d,
    lime1 = 0xc0ca33,
    yellow1 = 0xfdd835,
    amber1 = 0xffb300,
    orange1 = 0xFF8E00,
    deeporange1 = 0xf4511e,
    brown1 = 0x6d4c41,
    grey1 = 0x757575,
    bluegray1 = 0x546e7a,
    white1 = 0xf7f7f7,
current1 = 0x43a047
}

-- General themes
local themes = colors.current1

local normal = themes
local warn = 0xff7200
local crit = 0xff000d

-- Background settings
local corner_r = 35
local bg_colour = 0x333333
local bg_alpha = 0.2

-- Define settings for various display elements
local settings_table = {
    -- Example CPU ring definition
    {
        name='cpu',
        arg='freq_g',
        max=110,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=0xdd45,
        fg_alpha=0.8,
        x=200, y=120,
        radius=105,
        thickness=4,
        start_angle=-11,
        end_angle=100
    },
    {
        name='cpu',
        arg='cpu0',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=200, y=120,
        radius=86,
        thickness=13,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=200, y=120,
        radius=71,
        thickness=12,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=200, y=120,
        radius=57,
        thickness=11,
        start_angle=0,
        end_angle=240
    },
    {
        name='cpu',
        arg='cpu3',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=200, y=120,
        radius=44,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='memperc',
        arg='',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=340, y=234,
        radius=60,
        thickness=15,
        start_angle=180,
        end_angle=420
    },
    {
        name='swapperc',
        arg='',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=340, y=234,
        radius=45,
        thickness=10,
        start_angle=180,
        end_angle=420
    },
    {
        name='fs_used_perc',
        arg='/',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=220, y=280,
        radius=40,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/home',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=220, y=280,
        radius=28,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='fs_used_perc',
        arg='/usr',
        max=100,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=220, y=280,
        radius=16,
        thickness=10,
        start_angle=0,
        end_angle=240
    },
    {
        name='downspeedf',
        arg='',
        max=13700,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=290, y=346,
        radius=30,
        thickness=12,
        start_angle=180,
        end_angle=420
    },
    {
        name='downspeedf',
        arg='2',
        max=13700,
        bg_colour=themes,
        bg_alpha=0.8,
        fg_colour=themes,
        fg_alpha=0.8,
        x=290, y=346,
        radius=30,
        thickness=12,
        start_angle=180,
        end_angle=-170
    },
    {
        name='upspeedf',
        arg='',
        max=13800,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=290, y=346,
        radius=18,
        thickness=8,
        start_angle=180,
        end_angle=420
    },
    {
        name='upspeedf',
        arg='2',
        max=13800,
        bg_colour=themes,
        bg_alpha=0.8,
        fg_colour=themes,
        fg_alpha=0.8,
        x=290, y=346,
        radius=18,
        thickness=8,
        start_angle=180,
        end_angle=-176
    },

    {
        name='battery_percent',
        arg='BAT0',
        max=95,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=222, y=385,
        radius=20,
        thickness=7,
        start_angle=0,
        end_angle=240
    },
    {
        name='battery_time',
        arg='BAT0',
        max=5,
        bg_colour=0xd9d9d9,
        bg_alpha=0.2,
        fg_colour=themes,
        fg_alpha=0.8,
        x=222, y=385,
        radius=10,
        thickness=6,
        start_angle=0,
        end_angle=240
    },
}

-- Ensure the correct module name 'cairo' is used
require 'cairo'

-- Helper function to convert color values to RGBA
local function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255, ((colour / 0x100) % 0x100) / 255, (colour % 0x100) / 255, alpha
end

-- Function to draw rings
local function draw_ring(cr, t, pt)
    local xc, yc, ring_r, ring_w, sa, ea = pt.x, pt.y, pt.radius, pt.thickness, pt.start_angle, pt.end_angle
    local bgc, bga, fgc, fga = pt.bg_colour, pt.bg_alpha, pt.fg_colour, pt.fg_alpha

    local angle_0 = sa * (2 * math.pi / 360) - math.pi / 2
    local angle_f = ea * (2 * math.pi / 360) - math.pi / 2
    local t_arc = t * (angle_f - angle_0)

    cairo_arc(cr, xc, yc, ring_r, angle_0, angle_f)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(bgc, bga))
    cairo_set_line_width(cr, ring_w)
    cairo_stroke(cr)

    cairo_arc(cr, xc, yc, ring_r, angle_0, angle_0 + t_arc)
    cairo_set_source_rgba(cr, rgb_to_r_g_b(fgc, fga))
    cairo_stroke(cr)
end

-- Function to setup rings based on conky variables
local function setup_rings(cr, pt)
    local value = tonumber(conky_parse(string.format('${%s %s}', pt.name, pt.arg)))
    if not value then value = 0 end
    local pct = value / pt.max
    draw_ring(cr, pct, pt)
end

-- Main function for ring statistics
function conky_ring_stats()
    if not conky_window then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)
    local updates = tonumber(conky_parse('${updates}'))

    if updates > 5 then
        for _, pt in ipairs(settings_table) do
            setup_rings(cr, pt)
        end
    end

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end

-- Initialization function for Conky
function conky_main()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr = cairo_create(cs)

    conky_ring_stats()

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
end
