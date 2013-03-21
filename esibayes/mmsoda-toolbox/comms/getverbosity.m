function getverbosity()

verbosity = evalin('base','verbosity');
assignin('caller','verbosity',verbosity);
