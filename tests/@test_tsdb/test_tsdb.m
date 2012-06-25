function t = test_tsdb(name)
%
%  Example
%  =======
%         run(gui_test_runner, 'test_tsdb');

%  $Id: test_tsdb.m,v 1.1.1.1 2007/08/01 14:16:20 h856605 Exp $

tc = test_case(name);
t = class(struct([]), 'test_tsdb', tc);