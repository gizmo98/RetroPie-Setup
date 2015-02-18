#!/usr/bin/env python3
import configparser
import shutil
import os

section = 'start'

# write RetroArch Autoconfig
def WriteAutoConfig(main_parser, filename):
    # add special keys
    main_parser = AutoConfigHelper(main_parser,'input_enable_hotkey','input_select')
    main_parser = AutoConfigHelper(main_parser,'input_exit_emulator','input_start')
    main_parser = AutoConfigHelper(main_parser,'input_menu_toggle','input_x')
    main_parser = AutoConfigHelper(main_parser,'input_load_state','input_l')
    main_parser = AutoConfigHelper(main_parser,'input_save_state','input_r')
    main_parser = AutoConfigHelper(main_parser,'input_reset','input_b')
    main_parser = AutoConfigHelper(main_parser,'input_state_slot_increase','input_right')
    main_parser = AutoConfigHelper(main_parser,'input_state_slot_decrease','input_left')

    # write autoconfig
    with open(filename, 'w') as configfile:
        main_parser.write(configfile)
        configfile.close()

    # read config file, delete section and write autoconfig
    config = open(filename).read()
    with open(filename,'w') as configfile:
        configfile.write(RemoveDummySection(config))
        configfile.close()
    return(0)

# Add dummy section. ini parser needs at least one section
def AddDummySection(string):
    return ('[start]\n' + string)

# Remove dummy section. retroarch needs no section
def RemoveDummySection(string):
    return (string.replace('[start]\n',''))

# change main_parser key settings
def AutoConfigHelper(parser, hotkey, key):
    if parser.has_option(section,   key + '_axis'):
        parser.set(section, hotkey  + '_axis', parser.get(section,key + '_axis'))
    elif parser.has_option(section, key + '_btn'):
        parser.set(section, hotkey  + '_btn',  parser.get(section,key + '_btn'))
    return(parser)

########################################################################################
# main script
########################################################################################
# path variables
home            = '/opt'
auto_path       = home + '/retropie/emulators/retroarch/configs/'

for filename in os.listdir(auto_path):
    main_cfg  = open(filename).read()

    # Remove section if necessary
    config = RemoveDummySection(main_cfg)

    # Add a section at the beginning. Configparser needs at least one section
    config  = AddDummySection(main_cfg)

    # Add a configparser and read config
    parser  = configparser.ConfigParser()
    parser.read_string(config)

    # Add config to retroarch autoconfig /RetroPie/emulators/RetroArch/configs/*.cfg
    WriteAutoConfig(parser, filename)
exit()
########################################################################################
# End
########################################################################################
