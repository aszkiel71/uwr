cyfry = {}

cyfry[0] = """
 ###  
#   #
#   #
#   #
 ###
"""

cyfry[1] = """
  #
 ##
  #
  #
 ###
"""

cyfry[4] = """
 # 
#
#####
  #
  #
"""


cyfry[2] = """
 ###  
#   #
  ##
 #
#####
"""

cyfry[5] = """
##### 
#   
####
    #
####
"""

cyfry[8] = """
 ###  
#   #
 ### 
#   #
 ###
"""

cyfry[6] = """
 ###  
#   
#### 
#   #
 ###
"""

cyfry[9] = """
 ###  
#   #
 ####
    #
 ###
"""

cyfry[3] = """
####  
    #
 ### 
    #
####
"""

cyfry[7] = """
#####
   #
 ###
 #
# 
"""

pytajnik = """
 ###  
#   #
  ##
   
  #
"""

def popraw(s):
    L = s.split('\n')
    for i in range(len(L)):
        if len(L[i]) < 5:
            L[i] += (5-len(L[i])) * " "
        else:
            L[i] = L[i][:5]   
    return L[1:-1]      

def daj_cyfre(n):
   if n not in range(10):
       return popraw(pytajnik)
   return popraw(cyfry[n])
   
