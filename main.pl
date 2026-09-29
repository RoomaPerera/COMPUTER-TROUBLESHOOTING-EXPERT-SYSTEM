% ============================================================
% COMPUTER TROUBLESHOOTING EXPERT SYSTEM
% CM3321 - Logic Programming and Artificial Cognitive Systems
%
% Implementation: SWI-Prolog
%
% Knowledge sources:
% S1 - Dell: No Power / No POST / No Boot / No Video
% S2 - Dell: Desktop Diagnostic Beep Codes
% S3 - Intel: Processor Overheating Troubleshooting
% S4 - Intel: Random Restart / Shutdown Troubleshooting
% S5 - Seagate: S.M.A.R.T. Error Documentation
% S6 - Seagate: SeaTools / SSD Diagnostic Documentation
% S7 - Microsoft: Windows Wi-Fi Troubleshooting
% ============================================================

:- dynamic known/2.

% ============================================================
% MAIN PROGRAM
% ============================================================

start :-
  clear_answers,
  print_header,
  choose_category(Category),
  nl,
  writeln('The system will now ask questions relevant to the selected problem.'),
  writeln('Please answer yes or no.'),
  nl,
  backward_results(Category, Results),
  show_results(Results),
  clear_answers.

% Optional forward-chaining execution
start_forward :-
  clear_answers,
  print_header,
  choose_category(Category),
  nl,
  writeln('FORWARD CHAINING MODE'),
  writeln('Please answer all questions for the selected category.'),
  nl,
  collect_category_facts(Category),
  forward_results(Category, Results),
  show_results(Results),
  clear_answers.

print_header :-
  nl,
  writeln('=========================================================='),
  writeln('        COMPUTER TROUBLESHOOTING EXPERT SYSTEM'),
  writeln('=========================================================='),
  nl.

% ============================================================
% CATEGORY SELECTION
% ============================================================

choose_category(Category) :-
  writeln('Select the type of problem:'),
  nl,
  writeln('1. Power / Startup'),
  writeln('2. Display / POST / Memory'),
  writeln('3. Overheating / Random Restart'),
  writeln('4. Storage / Drive'),
  writeln('5. Network / Wi-Fi'),
  nl,
  write('Enter option (1-5): '),

  read_line_to_string(user_input, Input0),
  normalize_space(string(Input), Input0),

  (
    category_from_input(Input, Category) -> true;
    nl, writeln('Invalid option. Please enter a number from 1 to 5.'), nl, choose_category(Category)
  ).


category_from_input("1", power_startup).
category_from_input("2", display_post).
category_from_input("3", overheating_restart).
category_from_input("4", storage).
category_from_input("5", network).

% ============================================================
% QUESTIONS / DOMAIN FACTS
% ============================================================

question(no_power_led, 'Is the power LED off?').
question(no_signs_of_life, 'Does the computer show no signs of life?').
question(desktop_no_power, 'Is this a desktop computer that does not power on?').
question(power_cable_not_verified, 'Have the power cable, outlet, and power strip NOT yet been verified as working?').
question(laptop_no_power, 'Is this a laptop that does not power on?').
question(adapter_led_off, 'Is the AC adapter LED off?').
question(stuck_at_logo, 'Does the computer remain stuck at the manufacturer logo?').
question(startup_beeps_or_diagnostic_leds, 'Are there beep sounds or diagnostic LED flashes during startup?').
question(reaches_logo, 'Does the computer reach the manufacturer logo screen?').
question(windows_not_loading, 'Does Windows fail to start loading after the logo screen?').
question(power_normal, 'Does the computer appear to receive normal power?').
question(computer_running, 'Does the computer appear to be running?').
question(blank_screen, 'Does the screen remain blank?').
question(monitor_self_test_absent, 'When the display cable is disconnected, does the monitor fail to show its self-test message?').
question(video_during_post, 'Is video visible during the initial POST/startup stage?').
question(screen_blank_after_post, 'Does the screen become blank after the initial startup stage?').
question(dell_inspiron_desktop, 'Is the computer an applicable Dell Inspiron desktop?').
question(beep_code_2, 'Does the Dell desktop produce diagnostic beep code 2?').
question(beep_code_4, 'Does the Dell desktop produce diagnostic beep code 4?').
question(beep_code_6, 'Does the Dell desktop produce diagnostic beep code 6?').
question(beep_code_7, 'Does the Dell desktop produce diagnostic beep code 7?').
question(dell_optiplex_applicable,'Is this an applicable Dell OptiPlex system using the documented legacy beep pattern?').
question(beep_pattern_1_3_2,'Does the system produce the 1-3-2 diagnostic beep pattern?').
question(shuts_down_shortly, 'Does the computer automatically shut down after operating for a short time?').
question(cpu_frequency_low, 'Is the CPU operating below its expected frequency?').
question(cpu_throttling,'Is processor thermal throttling being reported?').
question(system_slow,'Is the computer unusually slow?').
question(excessive_fan_noise,'Is the cooling fan unusually loud or continuously running at high speed?').
question(cpu_fan_not_running,'Is the CPU/system cooling fan not running?').
question(fan_blocked,'Is the cooling fan or ventilation path obstructed?').
question(random_reboot,'Does the computer randomly reboot or shut down?').
question(psu_insufficient,'Is the power supply known to provide insufficient wattage for the system under load?').
question(memory_test_failed, 'Did a memory diagnostic test report an error or failure?').
question(smart_error, 'Has the storage drive reported a S.M.A.R.T. warning or error?').
question(smart_temperature_warning,'Is the S.M.A.R.T. warning related to excessive drive temperature?').
question(seatools_failed, 'Did the drive fail a SeaTools diagnostic test?').
question(pc_no_wifi,'Is this PC unable to connect to the Wi-Fi network?').
question(other_device_connects, 'Can another device connect successfully to the same Wi-Fi network?').
question(apipa_address,'Does the PC have an IP address beginning with 169.254?').

% ============================================================
% KNOWLEDGE BASE - 25 RULES
% ============================================================

% ------------------------------------------------------------
% POWER / STARTUP RULES
% ------------------------------------------------------------

% R01 - Dell S1
rule(
  'R01',
  power_startup,
  [no_power_led, no_signs_of_life],
  no_power_condition,
  'The computer matches a No Power condition. Check the power source and power connections.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R02 - Dell S1
rule(
  'R02',
  power_startup,
  [desktop_no_power, power_cable_not_verified],
  check_desktop_power_connection,
  'Check and reseat the desktop power cable, electrical outlet, and power strip.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R03 - Dell S1
rule(
  'R03',
  power_startup,
  [laptop_no_power, adapter_led_off],
  possible_ac_adapter_problem,
  'Check the AC adapter and power source. A known-working compatible adapter may be used for testing.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R04 - Dell S1
rule(
  'R04',
  power_startup,
  [stuck_at_logo],
  possible_post_failure,
  'The system may be experiencing a POST failure because startup does not proceed beyond the manufacturer logo.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R05 - Dell S1
rule(
  'R05',
  display_post,
  [startup_beeps_or_diagnostic_leds],
  diagnostic_post_error,
  'A POST diagnostic condition is indicated. The beep or LED pattern should be checked against the manufacturer diagnostic documentation.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R06 - Dell S1
rule(
  'R06',
  power_startup,
  [reaches_logo, windows_not_loading],
  no_boot_condition,
  'The computer completes initial startup but Windows does not load. Investigate the operating system or boot/storage configuration.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R07 - Dell S1
rule(
  'R07',
  display_post,
  [power_normal, computer_running, blank_screen],
  no_video_condition,
  'The computer appears to operate but produces no video. Check the display, display cable, and graphics connection.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R08 - Dell S1
rule(
  'R08',
  display_post,
  [blank_screen, monitor_self_test_absent],
  possible_monitor_problem,
  'The display itself may require testing. Try a known-working monitor or perform the manufacturer display test.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% R09 - Dell S1
rule(
  'R09',
  display_post,
  [video_during_post, screen_blank_after_post],
  possible_display_or_graphics_driver_problem,
  'Because video is initially present and later disappears, investigate the display configuration or graphics driver.',
  'S1 - Dell No Power / No POST / No Boot / No Video documentation'
).

% ------------------------------------------------------------
% DELL MEMORY / HARDWARE DIAGNOSTIC RULES
% ------------------------------------------------------------

% R10 - Dell S2
rule(
  'R10',
  display_post,
  [dell_inspiron_desktop, beep_code_2],
  no_ram_detected,
  'The Dell diagnostic code indicates that RAM is not detected. Check the installed memory modules.',
  'S2 - Dell Desktop Diagnostic Beep Code documentation'
).

% R11 - Dell S2
rule(
  'R11',
  display_post,
  [dell_inspiron_desktop, beep_code_4],
  ram_failure,
  'The Dell diagnostic code indicates a RAM failure. Test or reseat the memory modules.',
  'S2 - Dell Desktop Diagnostic Beep Code documentation'
).

% R12 - Dell S2
rule(
  'R12',
  display_post,
  [dell_inspiron_desktop, beep_code_6],
  video_card_or_chip_failure,
  'The Dell diagnostic code indicates a video card or video chip problem.',
  'S2 - Dell Desktop Diagnostic Beep Code documentation'
).

% R13 - Dell S2
rule(
  'R13',
  display_post,
  [dell_inspiron_desktop, beep_code_7],
  cpu_failure,
  'The Dell diagnostic code indicates a CPU failure.',
  'S2 - Dell Desktop Diagnostic Beep Code documentation'
).

% R14 - Dell S2
rule(
  'R14',
  display_post,
  [dell_optiplex_applicable, beep_pattern_1_3_2],
  memory_problem,
  'The documented Dell diagnostic beep pattern indicates a memory problem.',
  'S2 - Dell Desktop Diagnostic Beep Code documentation'
).

% ------------------------------------------------------------
% OVERHEATING / RANDOM RESTART RULES
% ------------------------------------------------------------

% R15 - Intel S3
rule(
  'R15',
  overheating_restart,
  [shuts_down_shortly],
  possible_overheating,
  'Automatic shutdown after a short operating period can indicate overheating. Check system cooling and processor temperature.',
  'S3 - Intel Processor Overheating Troubleshooting documentation'
).

% R16 - Intel S3
rule(
  'R16',
  overheating_restart,
  [cpu_frequency_low, cpu_throttling],
  processor_thermal_throttling,
  'Reduced CPU frequency together with thermal throttling indicates a thermal condition.',
  'S3 - Intel Processor Overheating Troubleshooting documentation'
).

% R17 - Intel S3
rule(
  'R17',
  overheating_restart,
  [system_slow, excessive_fan_noise],
  possible_cooling_or_overheating_problem,
  'Slow performance together with excessive fan activity may indicate a cooling or overheating issue.',
  'S3 - Intel Processor Overheating Troubleshooting documentation'
).

% R18 - Intel S3
rule(
  'R18',
  overheating_restart,
  [cpu_fan_not_running, fan_blocked],
  cooling_system_problem,
  'The cooling system requires attention. Check the fan power connection and remove ventilation obstruction.',
  'S3 - Intel Processor Overheating Troubleshooting documentation'
).

% R19 - Intel S4
rule(
  'R19',
  overheating_restart,
  [random_reboot, psu_insufficient],
  possible_power_supply_problem,
  'Random rebooting with insufficient PSU capacity indicates that the power supply should be investigated.',
  'S4 - Intel Random Restart / Shutdown Troubleshooting documentation'
).

% R20 - Intel S4
rule(
  'R20',
  overheating_restart,
  [random_reboot, memory_test_failed],
  possible_memory_fault,
  'Random rebooting together with a failed memory diagnostic indicates a possible DRAM/memory fault.',
  'S4 - Intel Random Restart / Shutdown Troubleshooting documentation'
).

% ------------------------------------------------------------
% STORAGE RULES
% ------------------------------------------------------------

% R21 - Seagate S5
rule(
  'R21',
  storage,
  [smart_error],
  predicted_drive_failure,
  'A S.M.A.R.T. error can indicate predicted drive failure. Back up important data immediately and test the drive.',
  'S5 - Seagate S.M.A.R.T. Error documentation'
).

% R22 - Seagate S5
rule(
  'R22',
  storage,
  [smart_temperature_warning],
  drive_temperature_problem,
  'A temperature-related S.M.A.R.T. warning requires checking system ventilation and cooling.',
  'S5 - Seagate S.M.A.R.T. Error documentation'
).

% R23 - Seagate S6
rule(
  'R23',
  storage,
  [seatools_failed],
  defective_storage_drive,
  'The storage drive failed the manufacturer diagnostic test and should be considered for replacement.',
  'S6 - Seagate SeaTools / SSD Diagnostic documentation'
).

% ------------------------------------------------------------
% NETWORK RULES
% ------------------------------------------------------------

% R24 - Microsoft S7
rule(
  'R24',
  network,
  [pc_no_wifi, other_device_connects],
  problem_local_to_pc,
  'Because another device can use the same Wi-Fi network, troubleshoot the affected PC network configuration or adapter.',
  'S7 - Microsoft Windows Wi-Fi Troubleshooting documentation'
).

% R25 - Microsoft S7
rule(
  'R25',
  network,
  [apipa_address],
  dhcp_address_problem,
  'A 169.254.x.x address indicates that Windows did not obtain an IP address from the router. Check DHCP and network connectivity.',
  'S7 - Microsoft Windows Wi-Fi Troubleshooting documentation'
).

% ============================================================
% BACKWARD CHAINING
% ============================================================

backward_results(Category, Results) :-
  findall(
    result(ID, Conclusion, Recommendation, Source),
    (rule(ID, Category, Conditions, Conclusion, Recommendation, Source), prove_conditions(Conditions)),
    Results
  ).

prove_conditions([]).

prove_conditions([Fact | Rest]) :- verify(Fact), prove_conditions(Rest).

verify(Fact) :-known(Fact, yes), !.

verify(Fact) :- known(Fact, no), !, fail.

verify(Fact) :- question(Fact, Question), ask_for_proof(Fact, Question).


ask_for_proof(Fact, Question) :-
  format('~w (yes/no): ', [Question]),
  read_line_to_string(user_input, Input0),
  normalize_space(string(Input1), Input0),
  string_lower(Input1, Input),

  (
    member(Input, ["yes", "y"]) -> assertz(known(Fact, yes));
    member(Input, ["no", "n"]) -> assertz(known(Fact, no)), fail;
    writeln('Please enter only yes or no.'),
    ask_for_proof(Fact, Question)
  ).

% ============================================================
% FORWARD CHAINING
% ============================================================

collect_category_facts(Category) :-
  findall(Fact,(rule(_, Category, Conditions, _, _, _),member(Fact, Conditions)), RawFacts),

  sort(RawFacts, Facts),
  ask_all_facts(Facts).

ask_all_facts([]).

ask_all_facts([Fact | Rest]) :- collect_fact(Fact), ask_all_facts(Rest).

collect_fact(Fact) :- known(Fact, _), !.
collect_fact(Fact) :- question(Fact, Question), ask_and_store(Fact, Question).


ask_and_store(Fact, Question) :-
  format('~w (yes/no): ', [Question]),
  read_line_to_string(user_input, Input0),
  normalize_space(string(Input1), Input0),
  string_lower(Input1, Input),

  (
    member(Input, ["yes", "y"]) -> assertz(known(Fact, yes));
    member(Input, ["no", "n"]) -> assertz(known(Fact, no));
    writeln('Please enter only yes or no.'),
    ask_and_store(Fact, Question)
  ).

forward_results(Category, Results) :-
  findall(result(ID, Conclusion, Recommendation, Source),(rule(ID,Category,Conditions,Conclusion,Recommendation,Source),all_known_true(Conditions)), Results).

all_known_true([]).

all_known_true([Fact | Rest]) :- known(Fact, yes), all_known_true(Rest).

% ============================================================
% OUTPUT / EXPLANATION
% ============================================================

show_results([]) :-
  nl,
  writeln('=========================================================='),
  writeln('RESULT'),
  writeln('=========================================================='),
  writeln('No rule matched all of the supplied symptoms.'),
  writeln('The available information is insufficient for a conclusion.'),
  nl.

show_results(Results) :-
  Results \= [],
  nl,
  writeln('=========================================================='),
  writeln('RESULTS'),
  writeln('=========================================================='),
  show_result_list(Results).

show_result_list([]).

show_result_list([result(ID, Conclusion, Recommendation, Source) | Rest]) :-
  pretty_name(Conclusion, PrettyConclusion),
  nl,
  format('Rule triggered : ~w~n', [ID]),
  format('Conclusion     : ~w~n', [PrettyConclusion]),

  rule(ID, _, Conditions, _, _, _),

  write('Evidence used  : '),
  print_conditions(Conditions),
  nl,

  format('Recommendation : ~w~n', [Recommendation]),
  format('Knowledge source: ~w~n', [Source]),
  writeln('------------------------------------------------'),

  show_result_list(Rest).

pretty_name(Atom, Pretty) :- atomic_list_concat(Parts, '_', Atom), atomic_list_concat(Parts, ' ', Pretty).

print_conditions([]).

print_conditions([Fact]) :- pretty_name(Fact, Pretty),format('~w', [Pretty]).

print_conditions([Fact | Rest]) :- pretty_name(Fact, Pretty), format('~w, ', [Pretty]), print_conditions(Rest).

% ============================================================
% WORKING MEMORY MANAGEMENT
% ============================================================

clear_answers :- retractall(known(_, _)).

add_yes_fact(Fact) :- assertz(known(Fact, yes)).

add_test_facts([]).

add_test_facts([Fact | Rest]) :- add_yes_fact(Fact), add_test_facts(Rest).

% ============================================================
% AUTOMATED TEST CASES
% ============================================================

test_case(tc01) :- run_test_case('TC01', power_startup, [no_power_led, no_signs_of_life],'R01').
test_case(tc02) :- run_test_case('TC02',power_startup,[reaches_logo, windows_not_loading],'R06').
test_case(tc03) :- run_test_case('TC03',display_post,[dell_inspiron_desktop, beep_code_4],'R11').
test_case(tc04) :- run_test_case('TC04',overheating_restart,[shuts_down_shortly],'R15').
test_case(tc05) :- run_test_case('TC05',overheating_restart,[random_reboot, memory_test_failed],'R20').
test_case(tc06) :- run_test_case('TC06',storage,[smart_error],'R21').
test_case(tc07) :- run_test_case('TC07', storage, [seatools_failed], 'R23').
test_case(tc08) :- run_test_case('TC08', network, [pc_no_wifi, other_device_connects], 'R24').
test_case(tc09) :- run_test_case('TC09', network,[apipa_address],'R25').
test_case(tc10) :- run_test_case('TC10', display_post, [power_normal, computer_running, blank_screen], 'R07').

run_test_case(TestID, Category, Facts, ExpectedRule) :-
  clear_answers,
  nl,
  writeln('=========================================================='),
  format('TEST CASE: ~w~n', [TestID]),
  writeln('=========================================================='),

  format('Input facts   : ~w~n', [Facts]),
  format('Expected rule : ~w~n', [ExpectedRule]),

  add_test_facts(Facts),

  forward_results(Category, Results),

  extract_rule_ids(Results, IDs),

  format('Actual rules  : ~w~n', [IDs]),

  (
    member(ExpectedRule, IDs) -> writeln('TEST RESULT   : PASSED');
    writeln('TEST RESULT   : FAILED')
  ),

  show_results(Results),
  clear_answers.

extract_rule_ids([], []).
extract_rule_ids([result(ID, _, _, _) | Rest], [ID | IDs]) :- extract_rule_ids(Rest, IDs).

% Run all predefined test cases
run_all_tests :-
  test_case(tc01),
  test_case(tc02),
  test_case(tc03),
  test_case(tc04),
  test_case(tc05),
  test_case(tc06),
  test_case(tc07),
  test_case(tc08),
  test_case(tc09),
  test_case(tc10).