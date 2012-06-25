function suite = bits_all_tests
%bits_all_tests creates a test_suite with all test for bits.
%
%  Example
%  =======
%         run(gui_test_runner, 'bits_all_tests');

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author: h856605 $
%  $Id: bits_all_tests.m,v 1.2 2007/08/02 16:38:18 h856605 Exp $

suite = test_suite;
loader = test_loader;
suite = set_name(suite, 'bits_all_tests');
suite = add_test(suite, load_tests_from_test_case(loader, 'test_base' ));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_tsmat'));
suite = add_test(suite, load_tests_from_test_case(loader, 'test_tsdb' ));
