function self = test_fail(self)
%test_assert/test_fail tests invalid assertions.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_fail'');');
%
%  See also ASSERT, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

fail = 0;

% Without message
try
    assert(0);
    fprintf(1, 'assert(0) fails to fail.');
catch
end;
    
try
    assert(false);
	fail = 1;
catch
end;
assert(fail == 0, 'assert(false) fails to fail.');

% With message
try
    assert(0, 'Assertion must fail.');
catch
    assert(strfind(lasterr, 'Assertion must fail.'));
end;

% Equals
try
    assert_equals(0, 1);
    fail = 1;
catch
end;
assert(fail == 0, 'assert_equals(0, 1) fails to fail.');

% Not equals
try
    assert_not_equals(1, 1);
    fail = 1;
catch
end;
assert(fail == 0, 'assert_not_equals(1, 1) fails to fail.');
