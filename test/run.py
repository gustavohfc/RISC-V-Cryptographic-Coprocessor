from vunit import VUnit, VUnitCLI
from os.path import join, dirname
from shutil import copy2
from itertools import zip_longest
import re
import os
import glob

root = dirname(__file__)


coprocessor_tests = [
    {
        'message': 'abc',
        'md5': '900150983cd24fb0d6963f7d28e17f72',
        'sha1': 'a9993e364706816aba3e25717850c26c9cd0d89d',
        'sha256': 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
        'sha512': 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f'
    }
]


def copy_hex_files(vu):
    """ 
        TODO: Find a better way to copy this files without accessing private properties.
        More info about this workaround at https://github.com/VUnit/vunit/issues/236
    """
    if not os.path.exists(vu._simulator_output_path):
        os.mkdir(vu._simulator_output_path)

    # Copy all hex files from integration tests folder to the simulation path
    for file_path in glob.glob(join(root, "integration", "riscv_core", "*", "*.hex")):
        path, filename = os.path.split(file_path)
        _, test_name = os.path.split(path)
        copy2(file_path, join(vu._simulator_output_path, test_name + '_' + filename))

    for file_path in glob.glob(join(root, "integration", "cryptographic_coprocessor", "*.hex")):
        path, filename = os.path.split(file_path)
        _, test_name = os.path.split(path)
        copy2(file_path, join(vu._simulator_output_path, test_name + '_' + filename))

def make_integration_post_check(vu, test_name):
    """
    Return a check function to verify the output files
    """

    simulator_output_path = vu._simulator_output_path

    def post_check(output_path):
        expected_register_changes_path = join(root, "integration", "riscv_core", test_name, "register_changes.txt")
        simulated_register_changes_path = join(simulator_output_path, test_name + "_register_changes.txt")
        expected_memory_changes_path = join(root, "integration", "riscv_core", test_name, "memory_changes.txt")
        simulated_memory_changes_path = join(simulator_output_path, test_name + "_memory_changes.txt")

        if not compare_files(expected_register_changes_path, simulated_register_changes_path):
            return False

        if not compare_files(expected_memory_changes_path, simulated_memory_changes_path):
            return False

        return True

    return post_check

def compare_files(file_path_1, file_path_2):
    with open(file_path_1, 'r') as file_1, open(file_path_2, 'r') as file_2:
        for line_file_1, line_file_2 in zip_longest(file_1, file_2, fillvalue=""):
            if line_file_1 != line_file_2:
                print("ERROR: The files " + file_path_1 + " and " + file_path_2 + " aren't equal.")
                return False
    return True

def encode_string(s):
    return ', '.join(map(str, [ord(letter) for letter in s]))

if __name__ == "__main__":
    # Parse command line args
    cli = VUnitCLI()
    cli.parser.add_argument('--all', action='store_true')
    cli.parser.add_argument('--core-unit', action='store_true')
    cli.parser.add_argument('--coprocessor-unit', action='store_true')
    cli.parser.add_argument('--core-integration', action='store_true')
    cli.parser.add_argument('--coprocessor-integration', action='store_true')
    args = cli.parse_args()

    runAllTests = args.all or args.test_patterns != '*'

    # Create VUnit instance by parsing command line arguments
    vu = VUnit.from_args(args=args)

    # Create library 'lib'
    lib = vu.add_library("lib")

    # Add the source files
    lib.add_source_files(join(root, "..", "src", "*.vhd"))
    lib.add_source_files(join(root, "..", "src", "riscv_core", "*.vhd"))
    lib.add_source_files(join(root, "..", "src", "cryptographic_coprocessor", "*.vhd"))

    # Add the unit tests
    if runAllTests or args.core_unit:
        lib.add_source_files(join(root, "unit", "riscv_core", "*_tb.vhd"))
    
    if runAllTests or args.coprocessor_unit:
        lib.add_source_files(join(root, "unit", "cryptographic_coprocessor", "*_tb.vhd"))

    # Add the RISC-V core integration tests
    if runAllTests or args.core_integration:
        lib.add_source_files(join(root, "integration", "riscv_core", "integration_tb.vhd"))
        tb = lib.get_test_benches("*integration_tb*")[0]
        tb.add_config("simple_add", generics=dict(WSIZE=32, test_name="simple_add", PC_max=24), post_check=make_integration_post_check(vu, "simple_add"))
        tb.add_config("test_1", generics=dict(WSIZE=32, test_name="test_1", PC_max=216), post_check=make_integration_post_check(vu, "test_1"))
        tb.add_config("fibonacci", generics=dict(WSIZE=32, test_name="fibonacci", PC_max=60), post_check=make_integration_post_check(vu, "fibonacci"))
        tb.add_config("binary_search", generics=dict(WSIZE=32, test_name="binary_search", PC_max=180), post_check=make_integration_post_check(vu, "binary_search"))
        tb.add_config("branches", generics=dict(WSIZE=32, test_name="branches", PC_max=108), post_check=make_integration_post_check(vu, "branches"))

    # Add the coprocessor integration tests
    if runAllTests or args.coprocessor_integration:
        lib.add_source_files(join(root, "integration", "cryptographic_coprocessor", "coprocessor_integration_tb.vhd"))
        tb = lib.get_test_benches("*integration_tb*")[0]

        for i, test in enumerate(coprocessor_tests):
            message = encode_string(test['message'])
            message_len = len(test['message']) * 8
            md5 = encode_string(test['md5'])
            sha1 = encode_string(test['sha1'])
            sha256 = encode_string(test['sha256'])
            sha512 = encode_string(test['sha512'])
            tb.add_config("test_" + str(i), generics=dict(WSIZE=32, PC_max=24, message=message, message_len=message_len, md5=md5, sha1=sha1, sha256=sha256, sha512=sha512))

    copy_hex_files(vu)

    # Run vunit function
    vu.main()