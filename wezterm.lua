local wezterm = require "wezterm"

local config = {}
local custom_launch_menu = {}

-- 自定义颜色主题模块导入
-- 每次随机产生一个颜色主题
local color = (function()
    local COLOR = require "colors"
  
    local coolors = {
      COLOR.VERIDIAN,
      COLOR.PAYNE,
      COLOR.INDIGO,
      COLOR.CAROLINA,
      COLOR.FLAME,
      COLOR.JET,
      COLOR.TAUPE,
      COLOR.ECRU,
      COLOR.VIOLET
    }
  
    return coolors[math.random(#coolors)]
end)()
local color_primary = color
local title_color_bg = color_primary.bg
local title_color_fg = color_primary.fg

-- 配置Shell列表
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    table.insert(custom_launch_menu, {
        label = "PowerShell",
        args = { "pwsh.exe", "-nol" },
    })
    table.insert(custom_launch_menu, {
        label = "Ubuntu24",
        args = { "ubuntu2404.exe" }
    })
    table.insert(custom_launch_menu, {
        label = "GitBash",
        args = { "C:/Software/Git/bin/bash.exe", "-i", "-l" }
    })
    table.insert(custom_launch_menu, {
        label = "Cmd",
        args = { "cmd.exe" }
    })
    -- 默认终端
    config.default_prog = { "ubuntu2404.exe" }
elseif wezterm.target_triple == "aarch64-apple-darwin" then
    table.insert(custom_launch_menu, {
        label = 'zsh',
        args = {'/bin/zsh', '-l'}
    })
    -- 默认终端
    config.default_prog = {'/bin/zsh', '-l'}
end

-- 配置字体
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.font = wezterm.font_with_fallback {
        { family = 'JetBrains Mono', weight = 'Bold', italic = false },
        { family = 'FiraCode Nerd Font', weight = 'Medium', italic = false }
    }
    config.font_size = 11.0
elseif wezterm.target_triple == "aarch64-apple-darwin" then
    config.font = wezterm.font_with_fallback {
        { family = 'JetBrainsMono Nerd Font', weight = 'Bold', italic = false },
    }
    config.font_size = 11.0
end


-- 终端列表
config.launch_menu = custom_launch_menu

-- 快捷键
config.keys = {
    { key = 'w', mods = 'ALT', action = wezterm.action.ShowLauncher },
    { key = '9', mods = 'ALT', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
}

-- 窗口透明度
config.window_background_opacity = 0.95

-- 颜色主题
-- config.color_scheme = 'Apprentice (base16)'
-- config.color_scheme = 'Alien Blood (Gogh)'
config.color_scheme = 'Apprentice (Gogh)'
-- config.color_scheme = 'Atom'

-- 窗口配置
config.window_frame = {
    -- 字体
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold', italic = true }),
    -- 字体大小
    font_size = 11.0,
    -- title bar背景色
    active_titlebar_bg = title_color_bg,
    inactive_titlebar_bg = title_color_bg
}

-- 初始窗口大小
config.initial_cols = 120
config.initial_rows = 40

config.enable_scroll_bar = true

-- 在标签栏显示关闭、最大化、最小化按钮
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
integrated_title_button_style = "Windows"
integrated_title_button_color = "auto"
integrated_title_button_alignment = "Right"

-- 状态栏
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = false -- tab标签显示编号
config.switch_to_last_active_tab_when_closing_tab = true

-- 配置终端颜色类型
config.term = "xterm-256color"

-- GPU加速
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- 开启之后会打开速度变慢 所以不开启
    -- config.animation_fps = 60
    -- config.max_fps = 60
    -- config.front_end = "WebGpu"
    -- config.webgpu_power_preference = "HighPerformance"
elseif wezterm.target_triple == "aarch64-apple-darwin" then
    config.animation_fps = 60
    config.max_fps = 60
    config.front_end = "WebGpu"
    config.webgpu_power_preference = "HighPerformance"
end


-- 关闭窗口不提示
config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = {
    'bash',
    'sh',
    'zsh',
    'fish',
    'tmux',
    'nu',
    'cmd.exe',
    'pwsh.exe',
    'powershell.exe',
    'zsh.exe',
    'bash.exe'
}


-- 右侧状态显示
local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)
wezterm.on('update-right-status', function(window, pane)
  
    local time = wezterm.strftime '%H:%M:%S'
  
    local bg1 = title_color_bg:lighten(0.1)
    local bg2 = title_color_bg:lighten(0.2)
  
    window:set_right_status(
      wezterm.format {
        { Background = { Color = title_color_bg } },
        { Foreground = { Color = bg1 } },
        { Text = '' },
        { Background = { Color = title_color_bg:lighten(0.1) } },
        { Foreground = { Color = title_color_fg } },
        { Text = ' ' .. window:active_workspace() .. ' ' },
        { Foreground = { Color = bg1 } },
        { Background = { Color = bg2 } },
        { Text = '' },
        { Foreground = { Color = title_color_bg:lighten(0.4) } },
        { Foreground = { Color = title_color_fg } },
        { Text = ' ' .. time },
        { Foreground = { Color = bg2 } },
        { Background = { Color = title_color_bg } },
        { Text = '' }
      }
    )
end)

-- local TAB_EDGE_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
-- local TAB_EDGE_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick
local TAB_EDGE_LEFT = wezterm.nerdfonts.pl_right_hard_divider
local TAB_EDGE_RIGHT = wezterm.nerdfonts.pl_left_hard_divider

local function tab_title(tab_info)
  local title = tab_info.tab_title

  if title and #title > 0 then return title end

  return tab_info.active_pane.title:gsub("%.exe", "")
end
wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, hover, max_width)
    local edge_background = title_color_bg
    local background = title_color_bg:lighten(0.05)
    local foreground = title_color_fg

    if tab.is_active then
      background = background:lighten(0.1)
      foreground = foreground:lighten(0.1)
    elseif hover then
      background = background:lighten(0.2)
      foreground = foreground:lighten(0.2)
    end

    local edge_foreground = background

    local title = tab_title(tab)

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = TAB_EDGE_LEFT },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = TAB_EDGE_RIGHT },
    }
  end
)

-- 颜色配置
config.colors = {
    tab_bar = {
      active_tab = {
        bg_color = title_color_bg:lighten(0.03),
        fg_color = title_color_fg:lighten(0.8),
        intensity = "Bold",
      },
      inactive_tab = {
        bg_color = title_color_bg:lighten(0.01),
        fg_color = title_color_fg,
        intensity = "Half",
      },
      inactive_tab_edge = title_color_bg,
      new_tab = {
        bg_color = title_color_bg:darken(0.2),
        fg_color = title_color_bg:lighten(0.1),
      },
      new_tab_hover = {
        bg_color = title_color_bg:darken(0.3),
        fg_color = title_color_bg:lighten(0.2),
        italic = true,
      },
    },
    split = title_color_bg:lighten(0.3):desaturate(0.5),
    -- 滚动条滑块颜色
    scrollbar_thumb = "#AAAAAA",  -- 红色滑块
}

-- 毛玻璃效果
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- 开启之后拖动窗口超高延迟
    config.win32_system_backdrop = "Acrylic"
elseif wezterm.target_triple == "aarch64-apple-darwin" then
    config.macos_window_background_blur = 30
end

-- 配置鼠标
config.mouse_bindings = {
    {
		-- right clink select (not wezterm copy mode),copy, and if don't select anything, paste
		-- https://github.com/wez/wezterm/discussions/3541#discussioncomment-5633570
		event = { Down = { streak = 1, button = 'Right' } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(wezterm.action.ClearSelection, pane)
			else
				window:perform_action(wezterm.action({
					PasteFrom = "Clipboard"
				}), pane)
			end
		end)
	},
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'NONE',
		-- action = act.CompleteSelection('ClipboardAndPrimarySelection'),
		action = wezterm.action.Nop
	},
	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
