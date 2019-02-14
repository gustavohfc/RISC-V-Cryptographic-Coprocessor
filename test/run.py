from vunit import VUnit
from os.path import join, dirname
from shutil import copy2
import re
import os

root = dirname(__file__)

def copy_mif_files(vu):
    """ 
        TODO: Find a better way to copy this files without accessing private properties.
        More info about this workaround at https://github.com/VUnit/vunit/issues/236
    """
    if not os.path.exists(vu._simulator_output_path):
        os.mkdir(vu._simulator_output_path)

    copy2(join(root, "..", "MEM_DADOS.mif"), join(vu._simulator_output_path, "MEM_DADOS.mif")) # TODO: Use a specific data memory initialization file for each test

    # Copy all mif files from integration tests folder to the simulation path
    for file in os.listdir(join(root, "integration")):
        if file.endswith(".mif"):
            copy2(join(root, "integration", file), vu._simulator_output_path)

def extract_test_name(output_path):
    return re.search(".*lib\.integration_tb\.(.*)_.*", output_path).group(1)

# def pre_config(output_path):
#     print(extract_test_name(output_path))
#     copy2(join(root, "..", "MEM_DADOS.mif"), join(output_path))
#     return True

if __name__ == "__main__":
    # Create VUnit instance by parsing command line arguments
    vu = VUnit.from_argv()

    # Create library 'lib'
    lib = vu.add_library("lib")

    # Add all files ending in .vhd in current working directory to library
    lib.add_source_files(join(root, "..", "src" , "*.vhd"))

    # Integration tests
    lib.add_source_files(join(root, "integration/integration_tb.vhd"))
    #tbs = lib.get_test_benches()
    tb = lib.get_test_benches("*integration_tb*")[0]
    tb.add_config("test_1", generics=dict(WSIZE=32, test_name="test_1"))
    #tb.add_config("test_2", generics=dict(WSIZE=32, test_name="test_2"))

    copy_mif_files(vu)

    # Run vunit function
    vu.main()