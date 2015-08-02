class component::virtualbox {
  apt::source { 'virtualbox':
    location    => 'http://download.virtualbox.org/virtualbox/debian',
    repos       => 'contrib',
    key         => '7B0FAB3A13B907435925D9C954422A4B98AB5139',
    key_source  => 'https://www.virtualbox.org/download/oracle_vbox.asc',
    include_src => false,
  } ->
  package { 'virtualbox-5.0': }
}
