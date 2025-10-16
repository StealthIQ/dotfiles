conky.config = {
  background = true,
  update_interval = 1,

  cpu_avg_samples = 2,
  net_avg_samples = 2,
  temperature_unit = celsius,

  double_buffer = true,
  no_buffers = true,
  text_buffer_size = 2048,

  gap_x = 1,
  gap_y = 1,

  minimum_height = 520,
  minimum_width = 520,
  maximum_width = 520,

  own_window = true,
  own_window_class = 'Conky',
  own_window_type = 'desktop',
  own_window_argb_visual = true,
  own_window_argb_value = 0,
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
  border_inner_margin = 0,
  border_outer_margin = 0,
  alignment = 'middle_right',

  draw_shades = false,
  draw_outline = false,
  draw_borders = false,
  draw_graph_borders = false,

  override_utf8_locale = true,
  use_xft = true,
  xftalpha = 0.8,
  uppercase = false,

  default_color = 'E5E5E5',
  color1 = 'E5E5E5',
  color2 = 'E5E5E5',
  color3 = '888888',
  color4 = 'fae4df',
  color5 = 'e6d5ec',

  lua_load = '~/.config/conky/rings-v1.2.1.lua',
  lua_draw_hook_post = 'conky_main'
}

conky.text = [[
<span class="math-inline">\{font Michroma\:size\=10\}</span>{color1}<span class="math-inline">\{goto 350\}</span>{voffset 18}<span class="math-inline">\{distribution\}
\#</span>{font Michroma:size=10}<span class="math-inline">\{color0\}</span>{goto 365}<span class="math-inline">\{voffset 18\}</span>{} HU
<span class="math-inline">\{<1\>font Play\:normal\:size\=10\}</span>{voffset 5}<span class="math-inline">\{color1\}</span>{goto 120}<span class="math-inline">\{freq\_g\} Ghz</span>{alignr 330}
<span class="math-inline">\{font Play\:normal\:size\=8\}</span>{voffset 0}<span class="math-inline">\{goto 120\}</span>{color1}CPU 1 <span class="math-inline">\{alignr 330\}</span>{color1}${cpu cpu0}%
<span class="math-inline">\{font Play\:normal\:size\=8\}</span>{voffset 2}<span class="math-inline">\{goto 120\}</span>{color1}CPU 2${alignr 330}<span class="math-inline">\{color1\}</span>{cpu cpu1}%
<span class="math-inline">\{font Play\:normal\:size\=8\}</span>{voffset 2}<span class="math-inline">\{goto 120\}</span>{color1}CPU 3${alignr 330}<span class="math-inline">\{color1\}</span>{cpu cpu2}%
<span class="math-inline">\{font Play\:normal\:size\=8\}</span>{voffset 2}<span class="math-inline">\{goto 120\}</span>{color1}CPU 4${alignr 330}<span class="math-inline">\{color1\}</span>{cpu cpu3}%
<span class="math-inline">\{goto 50\}</span>{voffset 9}<span class="math-inline">\{font Play\:normal\:size\=9\}</span>{color1}<span class="math-inline">\{top name 1\}</span>{alignr 306}${top cpu 1}%
<span class="math-inline">\{goto 50\}</span>{voffset 9}<span class="math-inline">\{font Play\:normal\:size\=9\}</span>{color1}<span class="math-inline">\{top name 2\}</span>{alignr 306}${top cpu 2}%
<span class="math-inline">\{goto 50\}</span>{voffset 9}<span class="math-inline">\{<1\>font Play\:normal\:size\=9\}</span>{color1}<span class="math-inline">\{top name 3\}</span>{alignr 306}${top cpu 3}%
<span class="math-inline">\{font Michroma\:size\=10\}</span>{color1}<span class="math-inline">\{goto 80\}</span>{voffset 4}CPU 
<span class="math-inline">\{font Michroma\:size\=10\}</span>{color1}<span class="math-inline">\{goto 394\}</span>{voffset 37}MEMORY
<span class="math-inline">\{goto 324\}</span>{voffset -6}${font Play:normal:size=
