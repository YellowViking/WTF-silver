# Settings start
JAR_FILE = 'translator.jar'
SILVER_COMPILE = './compile'
SAMPLE_FOLDER = 'samples/'
BASE_PATH = """/home/cby1990/silver/wtf!?"""
#Setting end

class TestFailure(Exception):
    def __init__(self,reason,case):
        self.reason=reason
        self.case=case
    def __str__(self):
        return "Test Failed on case [%s]:%s" %(str(self.case),self.reason)
class TestSuite:
    class TestFile:
        def __str__(self):
            return self.dsl
        def __init__(self,dsl):
            self.dsl=dsl
            self.cpp=self.dsl+'.cpp'
            self.output=self.dsl+'.output'
            self.expected=self.dsl[:-4]+'.expected'
            self.cppexec=self.dsl+'.out'
        def compile_dsl(self):
            import os
            if os.system("java -jar %s %s" %(JAR_FILE,self.dsl)) != 0:
                self.error("failed to generated cpp.")
        def compile_cpp(self):
            import os
            if not os.path.exists(self.cpp):
                self.error("cpp file does not exists.")
            compile = "g++ %s -o %s" %(self.cpp,self.cppexec)
            status=os.system(compile)
            if status != 0:
                self.error("g++ exited unexpectedly.")
        def run_exec(self):    
            import subprocess
            import os
            if not os.path.exists(self.cppexec):
                self.error("executable not found!")
            import sys
            sys.stdout.write('running ' + os.path.abspath('./' + self.cppexec) + ' ...')
            self.exec_output = subprocess.check_output(os.path.abspath('./' + self.cppexec),cwd=SAMPLE_FOLDER)
            sys.stdout.write('done.\n')
        def diff(self):    
            import difflib
            def d(a,b):
                return a == b
            result = d(open(self.expected).read(), self.exec_output)
            
            if not result:
                self.error('failed to match expected data, output is written to => %s'%self.output)
                open(self.output,'w+').write(self.exec_output)
        def test(self):
            self.compile_dsl()
            self.compile_cpp()
            import os
            self.run_exec()
            if os.path.exists(self.expected):
                print 'checking expected data from [%s]' % self.expected
                self.diff()
            return True
        def clean_up(self):
            import os
            try:
                #os.remove(self.output)
                os.remove(self.cpp)
            except:
                pass
        def error(self, description):
            raise TestFailure(description,self)
    def collect_test_files(self):
        import glob
        dsls=glob.glob(SAMPLE_FOLDER + "*.dsl")
        self.dsls=dsls
    def silver_compile_test(self):
        import os
        os.system(SILVER_COMPILE)
        import os
        if not os.path.exists(JAR_FILE):
            print 'silver-compile failed. TestSuite aborted.'
            return False
        return True
    def codegen_tests(self):
        self.num_cases = len(self.dsls)
	if self.num_cases == 0: print 'invalid case number'; return False;
        self.num_cases_passed = 0
        self.num_cases_failed = 0
        for case in self.dsls:
            testfile=TestSuite.TestFile(case)
            try:
                testfile.clean_up()
                testfile.test()
                self.num_cases_passed += 1
                print 'OK.'
            except Exception as ex:
                print ex
                self.num_cases_failed += 1
                print 'Failed.'
                
        print 'Test %d cases done.' %self.num_cases
        print '%s of cases passed'% self.num_cases_passed
        print '%s of cases failed'% self.num_cases_failed
        print 'Success rate %f%%' %(self.num_cases_passed*100/self.num_cases)
    def test_all(self):
        if self.silver_compile_test():
            self.collect_test_files()
            self.codegen_tests()
            
print 'TestSuite Starting ...'
import os
os.chdir(BASE_PATH)
print 'Changing path to => %s'%BASE_PATH
testSuite = TestSuite()
testSuite.test_all()
        
