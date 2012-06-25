%bits_test executes bits_all_tests with the text_test_runner.
%
%  Example
%  =======
%         bits_test;

runner = text_test_runner(1, 1);
run(runner, bits_all_tests);