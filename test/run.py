from vunit import VUnit, VUnitCLI
from os.path import join, dirname
from shutil import copy2
from itertools import zip_longest
import re
import os
import glob
import textwrap

root = dirname(__file__)


coprocessor_tests = [
    {
        'message': 'abc',
        'md5': '900150983cd24fb0d6963f7d28e17f72',
        'sha1': 'a9993e364706816aba3e25717850c26c9cd0d89d',
        'sha256': 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
        'sha512': 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f'
    },
    {
        'message': 'RISC-V',
        'md5': '61eadfbcdffdebf7c01d9aa685edd597',
        'sha1': '6c2f38c24f65569b89f9fc8f94f82701644c4af9',
        'sha256': '4200109c969f2698d34d7d84e3ff87cd584c227004a9b675f251aed43c9c412f',
        'sha512': '4e8a5d313c5f412cff7b8f844f057189a97b2ae816c3ea2bd1a42dd7c15860b6cddbcd50be49e9a9c830b2f3a2428ffe9dfcf111056077b89acf3f2619104b72'
    },
    # {
    #     'message': '',
    #     'md5': '',
    #     'sha1': '',
    #     'sha256': '',
    #     'sha512': ''
    # },
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

def encode_message(m):
    return ' '.join(map(str, [ord(letter) for letter in m]))

def encode_hash(h):
    return ' '.join(map(str, [int(byte, 16) for byte in textwrap.wrap(h, 2)]))

def generate_coprocessor_test_files(vu):
    """ 
        TODO: Find a better way to copy this files without accessing private properties.
        More info about this workaround at https://github.com/VUnit/vunit/issues/236
    """
    if not os.path.exists(vu._simulator_output_path):
        os.mkdir(vu._simulator_output_path)

    # for i, test in enumerate(coprocessor_tests):
    #     ih = IntelHex()

    #     ih[0x88] = len(test['message']) * 32
    #     # ih.puts(0x88, len(test['message']) * 32)

    #     next_addr = 0x8C
    #     for word in textwrap.wrap(test['message'], 8):
    #         ih.puts(next_addr, word)

    #     ih.write_hex_file(join(vu._simulator_output_path, "cryptographic_coprocessor_test_" + str(i) + "_data.hex"))

    for i, test in enumerate(coprocessor_tests):
        f = open(join(vu._simulator_output_path, "cryptographic_coprocessor_test_" + str(i) + "_in.hex"), 'w')

        f.write(encode_hash(test['md5']) + '\n')
        f.write(encode_hash(test['sha1']) + '\n')
        f.write(encode_hash(test['sha256']) + '\n')
        f.write(encode_hash(test['sha512']) + '\n')
        f.write(str(len(test['message']) * 8) + '\n')
        f.write(encode_message(test['message']) + '\n')

        f.close()
        
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

        copy_hex_files(vu)

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

        generate_coprocessor_test_files(vu)

        for i, test in enumerate(coprocessor_tests):
            test_name = "test_" + str(i)
            tb.add_config(test_name, generics=dict(test_name=test_name))

    copy_hex_files(vu)

    # Run vunit function
    vu.main()