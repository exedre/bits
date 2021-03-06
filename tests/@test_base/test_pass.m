function self = test_pass(self)
%test_assert/test_pass tests valid assertions.
%
%  Example
%  =======
%         run(gui_test_runner, 'test_assert(''test_pass'');');
%
%  See also ASSERT, ASSERT_EQUALS, ASSERT_NOT_EQUALS.

% Without message
assert(1);
assert(true);
assert(sin(pi/2) == cos(0));

% With message
assert(1, 'Assertion must pass, so message is never seen.');

% Equals
assert_equals(1, 1);
assert_equals('Foo', 'Foo');
assert_equals([1 2 3], [1 2 3]);
assert_equals(sin(1), sin(1));
assert_equals(true, true);

% Not equals
assert_not_equals(0, 1)
assert_not_equals('Foo', 'Bar');
assert_not_equals([1 2 3], [4 5 6]);
assert_not_equals(sin(0), sin(1));
assert_not_equals(true, false);