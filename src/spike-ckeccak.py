'''
spike-ckeccak – Spike extension with C implementation of sha3sum calculation

Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''
from subprocess import Popen, PIPE


def sha3override(self, filename):
    '''
    Calculate the hash sum of an entire file
    
    @param   filename:str  The filename of which to calculate the hash
    @return  :str          The hash sum in uppercase hexadecimal
    '''
    hashsum = Popen(['spike-ckeccak', filename], stdout = PIPE).communicate()[0]
    hashsum = hashsum.decode('utf-8', 'error')
    if hashsum.endswith('\n'):
        hashsum = hashsum[:-1]
    if '*' in hashsum:
        return sha3override_old(self, filename)
    return hashsum

sha3override_old = SHA3.digest_file
SHA3.digest_file = sha3override

