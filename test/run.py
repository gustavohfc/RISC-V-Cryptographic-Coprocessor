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
    {
        'message': 'A',
        'md5': '7fc56270e7a70fa81a5935b72eacbe29',
        'sha1': '6dcd4ce23d88e2ee9568ba546c007c63d9131c1b',
        'sha256': '559aead08264d5795d3909718cdd05abd49572e84fe55590eef31a88a08fdffd',
        'sha512': '21b4f4bd9e64ed355c3eb676a28ebedaf6d8f17bdc365995b319097153044080516bd083bfcce66121a3072646994c8430cc382b8dc543e84880183bf856cff5'
    },
    {
        'message': 'RISC-V with cryptographic coprocessor',
        'md5': '53adaabe137098735e96d87c227cbe32',
        'sha1': '0686680c53480a719aa250c837597746b836da6e',
        'sha256': '8a2f5da169063b5eaa01082e35afd01a2d809cf0be0565f3f60279030f04f71b',
        'sha512': 'a3b87a64c68175d3b5a832de1ff257e402df33a2a62994e792e760bc1f2049ff06b35a984de3cc36b46b1cc21eb8bb2a899cb85bb6513fee342f6f8d38bd8ea4'
    },
    {
        'message': 'U3uz5u5JayDTtEklk4FQuwk1676qaQKi',
        'md5': '3e2ddfb64483a2fb67dc83f7ea1c7b0f',
        'sha1': '85b4bf3b630065899461e410b8329c52ef0102d3',
        'sha256': '83feec7fe31a0dee7d52cb7b19e0d99e4bd09dd42df38ee2b1acecdb7b50b494',
        'sha512': 'f5030a5ca65825d066e6c1519016f0eba7f22f60e27e8c9bbc52416a8207f374334366043e4d2b308d22eea4c731254174aa292e3c75ea30b191564294363d97'
    },
    {
        'message': 'tubiTxcXT8qYGjVQzijzFzy5ofPj8MtEB0XbETn19hmaK3QwLwNqJR4P3AhQwUmFh',
        'md5': '2708a38f91f1429ae781c59ebbc5fd50',
        'sha1': '5c342330da4eee6ad3a945d1b7a9307958848b67',
        'sha256': '9d717d515a6d99fe42843d5237e947da97970980013ad86aa1c0044c1d5600ed',
        'sha512': 'db54572fe4ea236509382e46ca06f50873436520dd355208eb42e15e7bdfcb1b9aa3a4e4fa3265a7287fdd00dad6f22dda7c7a6c7f1d254fdfca6c18abae508b'
    },
    {
        'message': 'jJ4ndTmAa0aghInPHJUWm90n3WC29jcWWFZdv3Dxmto2jUs0OcbdpUo7CA9uDvR6nBoDPoVQ2CqvvKqDNN6iyLru1w15FUyRcGZCSaKhD00c1dU09fNsJLjzIYmmjlh',
        'md5': '8e5bc8e6ac1ba33cc14f63c4fcb15baa',
        'sha1': '37131989c15e50b64cd210199eb5c3e9498eda0a',
        'sha256': '5b3a2875be0f1172638b1d76cd39ac7f5f090081a8f7ea40f28e429260bc49be',
        'sha512': '6497f71c24051a70a8a6b6df88567a78dd5777bc08df6c5aeff9b94092c8025771996099ba82306fcbe39b8ab6f227b3d9d12b01ec979634d29b4e8beff60c0c'
    },
    {
        'message': 'RyWd2MSp8uPBBHFnNVBk8tqvOcjag1MmlFTxxaIhoCfi98rehC6NiPpQRu3TsJNAGVf2FCne43BypC55s5jxKwmwW6BIRWcgk7Bd0arXT5KS6J8VTNbFqDsWg2pnKz5DmkKuRgZLaphYB8J95C43rxtZZH9C0zQRFAeQFQBGSxcjdQAYSzdnNSdWMZ4q5XMSpWV6DhlJ2FJQIJzOSg37jJAY5DNWdt3C2DBo0JF5mV0RN6vS',
        'md5': '49a189c6a925670a4e8179da98e8fd49',
        'sha1': 'e089498d1de26547fe183d1bf155627ead2ad949',
        'sha256': '8d92010ec7e9b7bac27412a4c0d68836ef0d94b4d8fcea885b9d90787f972d2c',
        'sha512': '46d107da99b7cf2a17ac9e4126f6756bbecc9a7e09e0ac3163d8db1b20570e78e97df31b2b01b7130d5553a89c1e0d05bf5ec05150d71567a891882befb7513c'
    },
    {
        'message': '0eROp4gfusfvD1KMDHkDhjC4FYd5nVxLwNx5kDdus2JQnv1DTsL9Hlq1Z3a9GtnFLr9G7Euvdn3I7Ekw5JjOdU8NvvIchMvS3rNJSstyPfQqerzueRDLAcGcRzk8n4TSyISfesUNnoJ2KBA8gRdvjwxIih84gXRZK2ABhla09SdKWIN3pkGiZ3BaMupcXzu76oHBFR5dPEU2w5YdUiUyDq1A1einost8J8IVubR5G72UWQJVLSwZt2DAm9NR8gqWejRXRmInSNjQ7Z6EgfRfGwPWZWu4OZHPZNRVbnhVqje1hBrjSbTaLT92NUMcwwSvCqkLtN6uJ2OHyIWkekxiXTfxIFDkazEUzT6aMsN0zPAXINT8tCfVklPp1GtHsC40SDbbw1zNz8xnGIY5LPOhgK0AOWTAMHfNiANukzX7VdMLNodiWxti7FgKlI08bYhe5dZ7kqRps36djPxx8CrD9KAJ21q3K0Hx',
        'md5': '420320c0d6a12ec8bd8d2f179627507b',
        'sha1': 'e145ba6ca635e004fe4a74ff96617b9e51a1f833',
        'sha256': '2c1a20e2249d5cd4261718de84323526a6c72fafaa647241fa2a0925b321d8f4',
        'sha512': '066b64429a5bc4ed75ee55d8c740cedef441c2e3f7aca6ae4591823fde46aeae07f0f0d2703ba6fddbd924217d43c5c268a4e69e1a2ad94606510defa7ce844f'
    },
    {
        'message': 'hQeXvyz4uMEgJLE9mS5GPbCz2dXt4BjUsAMi7vEXGDORPln8zgXyGRQYF9G5ZIWKsg1AiK51K9gqZqQQ6s6Q0JWmp8LNxHEOHWu6GIXh8ZG6axg9FCvat4HMUV5NBDjM6kM3EsEOtwpaH7YLOqeIro2PfsKhxuVSBXfkD7b3iHcmNzMBGiebu3MNbzysm34Bb4yty3q4HhslFpXRyOOjMvdcinGRYdUFnvNPEzUGu8s5Mxsk9Lcv70wIZM3B4ppYXql15293zlAs7L0ZgV3MH6VFYzkrckUoFny4FJmjQ0pD8xxolyHYR7i1CW8qGOqiOMNux50sZOFWA7FqoPDFd2tm54dvgTavtxBwDc0176DFZ3KLRLhtjtsXj2JyXjDwC7PAP6YJ2X6TSuPaZbkRgNMwVDSfUi5ujzN5OnDjJGH0fDsEusmRND7Jh8cA7TpcJbLyDxWOmmIPSeiaV5mqRlehsg0nqRDau203vSO8bRpIEP7bLoMc',
        'md5': 'cf3c98ff20c2a9437cff973221484fed',
        'sha1': '8517519132ccbe74129b665ac205b1300b878f13',
        'sha256': '70340bd135a6e1e76aa35b0657e0f93c35908f7394b6d9e0e42a0f906cc29a08',
        'sha512': '54c2f5c416f527ca479e5eb81ff05c89d66efe76411b2fa202f3da07521f982ac6d4f94886b83d4ebdad80fb6b5098c04edd96ff7bd9e0c0566fadbe7e062182'
    },
    {
        'message': 'eNPmfJX5MbOccvuA0kfF6pfVPP3IpVzo7w3LzxyyGX2UHKOvYie4tMbZDQEGSSjf7WagWUzuYKEqfYJ7ICnNPXODGpj43iLBpYePHy5MrSV1P5QBJwRN2oGxDe3CM323uFHteK0mesWXiBOSM1TwoyMz9TYinx5xLb19Uqns8jKJ5nd4D8cuCQGDU4oerPr4qvZvNEewZdyFfdEuQb7lFad7mba7EB7JBK83WAqMnzpAMYxrboIg0NxMqE1qM1C1G8G9IgTnZOXv7fXGaZpe7FA3wXver6SJflXYjNKqga0yT4z2KE6OcQHUikAD0YJo7CE2eOOob2Jtfeh2d3RMxKZCol9xMV7kd1EVv6KSvVOsjA8FOLVS36zWGw20Au5czAweTp2GASjQeEUix7aKI1fYKofTAo73PKlQK8Bao9nWBXzg78kas1yalVYho67ksuVZFqxqBJjJO3b10RFa323C1znRSgDRm2dVxmBfb6qttwvO7x2QpHutbUQ9sDpiTvXolUhJE3mAjc5HxPq0l9wFtxo3dSsGlMdlu3Vd6us84mFHivvVmCIGN24YcNI8jXmQ',
        'md5': 'c33980a9bb75d023d0158cf66105820f',
        'sha1': '8f400f8f8d12315a779d26f491f01c806ec8ff3d',
        'sha256': '75a3a94b944dc043caaf97f7572f755d93c7edad6626097924ffe97d3ebce88b',
        'sha512': '4b952fc69968dd49539d7703f627c3c554392f4c161e8222dfb7eeae2f6ff767fcc42249141623ccb11eaf693532cb53b8ad3220c0a664b75e8a6126cbee2116'
    },
    {
        'message': 'pYrdhofQq52Ls9ztC8sGuO1Ueb0bVyMaHoaDmWoNiZ6AuQ4eTu8LaxTvWhufjnSUCt1cYa7Di47X4huy80nCiqynjGujsmFg8308HuVKT6mNNOE2mxzPkgSIDc7I9k5ioUKho38PEG8OEANyWnOGQ6NCdjKOxIdkfhGrlQY9Or3dFQhakj7kjqIO3GjLvPznKUeKD74rEkrnMRc5uMHUCM6owFT3LrObHYqm51AeCEvjNSOksh5CepFouXZS2dTRfIuDom70TKmVMzgin9DK1EHSdw5Dmap0pieMs9QwO6YVKgkWCImeTya7hJxjWZAUrFYicINu8VohK5aWclJDz2N4ZlBucUKB8GlzUPecT6jFDTnBEbuai9hiXvITa7SRlAFiFBCel2kYrO2wcS1IGGPF0JcXCyh0jdeLcyUhtCZYnq1AG2EcEsrF9p1oNhzEO74PJ4vb9aZOgx86xKAvcM1urnb9CvW6hEDLVgFmrVsm4Sgzp5WQA725qu0dMDw652gJdWRf5gHzVjOsJrSBbUxQoHoGubxCr9NMjr1ymCky2Ippez6aIGNJmkCUFoOBV1iif92aGrhkRDhBAMiSfHry',
        'md5': 'd635644e23acd2991fa4a0e14da0e1b0',
        'sha1': '36f929fa3c00a580f50e77dfde678ff508250df2',
        'sha256': '3dd5b35eadf9700a681097f92c67e7a94787f17596dee926738908d8857cfd54',
        'sha512': '36cb4bb21089bd43a80330aeb848fc12e755767d437fb5e95e163f46baf3482a417f109fc1c6877de909ce30b75eacd6edee784aae4be86ff33e8f0a8501549f'
    },
    {
        'message': 'etRresdeZn7RhoSDdsnNwpRtywQAiUrqVbFQmeMWLjN3DJgRrgnWl2uehoTZhzVWOEusCQBJurer5KKQGyOwezW0qqd6qZHrwG0p3HI2wn3MxSCFs6hViOTYzzdiD17DGUAhTgQzGvmGiNzpBN6WysElTOW7Te0wgDgdtAG93E11aiesGGBWyCwAllOKtK4TMEcy3IRFC3uBAdCLGknlj7KReth79OJ6UTsTLA2On05w15GW1XBdWOq2HcKAZeAdNJvpcFHPyXk0Hvb14pop5VxEJg0MVHTrdMdgkPWBYbwcZJTYOnWx8C3S0ZhsSE5xXvTBOJarWVhqibgvj3m2GYKTjdzUuxvB33eVU306H9PrFoJ8yKL1zhL9Hbuy3c9JrjmuRakasMn9H2Pt2T6r3LkTBzDYMDPvEVkP5hMgzq7Rqfouu1KEKh5bbYMSVaPIohzl4p5DJuEoslK8XzD5jWnDm79umNyqjfXPFkQhYefA0oEVEyE5iQPvNgDUcGVxUojop11VnfymsHVwm7mlbycpUzORjh5LNNkUjMOGhWT9Sqta1q9GcDRPgKqKz0fRCxa2d9ypauhLcqxYTUwcGA2JogYNLi7IFL5H8wkDF59ZuYGq5NTLOBIjbtUJh9S491lJtOgwVR',
        'md5': 'd878f3f34328deb785df3aae91e4cb74',
        'sha1': '0bd07b98f10900250be85ef0834026b4aa398dcb',
        'sha256': '010840411eed1236a6497c379677a0b264cf1ea589ee73892514058024c0cbdf',
        'sha512': 'a22a804281d31fe3bfad29d5a711fdddae7cf58a40f7f65fb6d7f51e756741bf5a022be654b195fd728db5d6d1f99f9c616d8b350b8b2b71f201d2b53782d1ee'
    },
    {
        'message': 'PK13Xxv24xzeIybMPmpyk9tAwMiFdvsgqvC9vFWMz2fSuJrH0gdmPrydmUI8vDQwi77PtRmv4RB7wc6Pn5uNvXUBtIGAhBBzJiIqhknKf65vEvuULkERaEx3i87JqzDyUkNd0YxKCGhdE9elav1hqIQkuP9bS8aeOIVKhDyTZQcOjvHRv4KjmjvBsuM9TcMiXg1IeMdvQfw2PVeaXiAFdOM1A0Qq5qonQ0dpstNlbai6KfZ3V1U0i6211okTrLLx1xQyLliAL4WAjzPTFukZmihd23KWovI1BSYBR2HfuCvot17LZeI34e6iVVwfvPZ0DWt0xC1KxrNlP0alCGrJD9QZ0igOlCZddkJUKEwIOH7MBqrZgOVu9RCSzoBqFReEVpfVlvURRjQrxnAdaMiCTb4jyKsJSNuu0TwxqksexWsP5T8nFdMJJNFHYZWN7T90w4N8bk2jY0nvhsseWzMCKnh7knlOjS6GjOTWNBGLV6w9gUgC08tdtgJ7RbA1O9LrDdmOI483tWOVlJOW69YJDI1C9RXTY0T1lSMDZ3XrtvwdsK7fGpfoU1f7ZyHL6APrgk1dqASd4LOJiXewQn6ETDBNRvhohXf0RoOu1Le680NluaYKGVLQxrYTeTTetJCKmIUMbc5VDLfgoQix4JzpdIlroQQhEidkApREPpJ40c5LkXbE5sphGqnKa4yy',
        'md5': '2cb5276d7b35a2879be7dea86a32ea0c',
        'sha1': '132573bb9c219987ed765f4c7c732d9a6a5b4b65',
        'sha256': '6045960c8889f552901cf03e0f589932115bfa929f7379eff786ee934f9a7482',
        'sha512': '3daf1a3a3ef2fca524722396b074a112e2e41c6e13454dfb639368a02b521d9539f4df3aef62c19521b748f04ec891f6d6862411782aef966bc399ed853f2b47'
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
        tb.add_config("loop", generics=dict(WSIZE=32, test_name="loop", PC_max=52), post_check=make_integration_post_check(vu, "loop"))

    # Add the coprocessor integration tests
    if runAllTests or args.coprocessor_integration:
        lib.add_source_files(join(root, "integration", "cryptographic_coprocessor", "coprocessor_integration_tb.vhd"))
        tb = lib.get_test_benches("*coprocessor_integration_tb*")[0]

        generate_coprocessor_test_files(vu)

        for i, test in enumerate(coprocessor_tests):
            test_name = "cryptographic_coprocessor_test_" + str(i)
            tb.add_config(test_name, generics=dict(test_name=test_name))

    copy_hex_files(vu)

    # Run vunit function
    vu.main()