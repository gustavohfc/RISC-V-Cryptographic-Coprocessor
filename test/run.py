from vunit import VUnit
from os.path import join, dirname
from shutil import copy2
from itertools import zip_longest
import re
import os

root = dirname(__file__)

def copy_hex_files(vu):
    """ 
        TODO: Find a better way to copy this files without accessing private properties.
        More info about this workaround at https://github.com/VUnit/vunit/issues/236
    """
    if not os.path.exists(vu._simulator_output_path):
        os.mkdir(vu._simulator_output_path)

    copy2(join(root, "..", "MEM_DADOS.mif"), vu._simulator_output_path) # TODO: Use a specific data memory initialization file for each test

    # Copy all mif files from integration tests folder to the simulation path
    for file in os.listdir(join(root, "integration")):
        if file.endswith(".hex"):
            copy2(join(root, "integration", file), vu._simulator_output_path)

def make_integration_post_check(vu, test_name):
    """
    Return a check function to verify the output files
    """

    simulator_output_path = vu._simulator_output_path

    def post_check(output_path):
        expected_register_changes_path = join(root, "integration", test_name + "_register_changes.txt")
        simulated_register_changes_path = join(simulator_output_path, test_name + "_register_changes.txt")

        if not compare_files(expected_register_changes_path, simulated_register_changes_path):
            return False

        # TODO: Check memory files

        return True

    return post_check

def compare_files(file_path_1, file_path_2):
    with open(file_path_1, 'r') as file_1, open(file_path_2, 'r') as file_2:
        for line_file_1, line_file_2 in zip_longest(file_1, file_2, fillvalue=""):
            if line_file_1 != line_file_2:
                print("ERROR: The files " + file_path_1 + " and " + file_path_2 + " aren't equal.")
                return False
    return True

if __name__ == "__main__":
    # Create VUnit instance by parsing command line arguments
    vu = VUnit.from_argv()

    # Create library 'lib'
    lib = vu.add_library("lib")

    # Add all files ending in .vhd in current working directory to library
    lib.add_source_files(join(root, "..", "src" , "*.vhd"))

    # Unit tests
    #lib.add_source_files(join(root, "unit", "*_tb.vhd"))

    # Integration tests
    lib.add_source_files(join(root, "integration/integration_tb.vhd"))
    tb = lib.get_test_benches("*integration_tb*")[0]
    tb.add_config("simple_add", generics=dict(WSIZE=32, test_name="simple_add", PC_max=24), post_check=make_integration_post_check(vu, "simple_add"))
    tb.add_config("test_1", generics=dict(WSIZE=32, test_name="test_1", PC_max=208), post_check=make_integration_post_check(vu, "test_1"))

    copy_hex_files(vu)

    # Run vunit function
    vu.main()