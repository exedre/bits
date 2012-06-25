function t = test_temp(name)
%test_assert tests the methods assert, assert_equals and assert_not_equals.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert');

%  $Author: h856605 $
%  $Id: test_temp.m,v 1.1.1.1 2007/08/01 14:16:20 h856605 Exp $

tc = test_case(name);
t = class(struct([]), 'test_temp', tc);
