

sign_mag_i = 0
sign_mag_j = 0
sum        = 0

with open("sign_mag_addr_rom.txt","w") as f:
      for i in range(0,16):
            for j in range(0,16):
                  if (i >= 8):
                        sign_mag_i = - 1 * (i - 8)
                  else:
                        sign_mag_i = i;
            
                  if (j >= 8):
                        sign_mag_j = - 1 * (j - 8)
                  else:
                        sign_mag_j = j;
            
                  sum = sign_mag_i + sign_mag_j
                  if (sum < 0):
                        if (sum <= - 8):
                              f.write("1" + f"{(abs(sum)-8):03b}" + "\n")
                        else:
                              f.write("1" + f"{abs(sum):03b}" + "\n")
                  else:
                        if (sum >= 8):
                              f.write(f"{abs(sum)-8:04b}"+ "\n")
                        else:
                              f.write(f"{abs(sum):04b}"+ "\n")
