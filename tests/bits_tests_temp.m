function suite = bits_all_tests
%bits_tests_temp creates a test_suite with temp test for bits.
%
%  Example
%  =======
%         run(gui_test_runner, 'bits_all_tests');

%  This Software and all associated files are released unter the 
%  GNU General Public License (GPL), see LICENSE for details.
%  
%  $Author: h856605 $
%  $Id: bits_tests_temp.m,v 1.1.1.1 2007/08/01 14:16:20 h856605 Exp $

suite = test_suite;
loader = test_loader;
suite = set_name(suite, 'bits_tests_temp');
suite = add_test(suite, load_tests_from_test_case(loader, 'test_temp'));
