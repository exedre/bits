function t = test_tsmat(name)
%
%  Example
%  =======
%         run(gui_test_runner, 'test_tsmat');

%  $Id: test_tsmat.m,v 1.1.1.1 2007/08/01 14:16:20 h856605 Exp $

tc = test_case(name);
t = class(struct([]), 'test_tsmat', tc);