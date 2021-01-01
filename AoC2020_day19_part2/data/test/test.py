def test(s,seq): # can we produce string s using rules list seq?
    if s == '' or seq == []: return s == '' and seq == [] # if both empty, True; if one, False
    # print the string at this point in time and the rule being applied
    #print(s+" "+str(rules[seq[0]]))
    r = rules[seq[0]]
    if '"' in r:
        return test(s[1:], seq[1:]) if s[0] in r else False # strip first character, False if cannot
    else:
        return any(test(s, t + seq[1:]) for t in r) # expand first term in seq rules list

def parse(s): # return rule pair (n,e) e.g. (2, [[2,3],[3,2]]) or (42,'"a"')
    n,e = s.split(": ")
    return (int(n),e) if '"' in e else (int(n), [[int(r) for r in t.split()] for t in e.split("|")])

# Read in all the text file, split the rules into rules_text and the strings to decode into messages
rule_text, messages = [x.splitlines() for x in open("Day19-Data.txt").read().split("\n\n")]

# Using the parse function build a rules list from the raw input file
rules = dict(parse(s) for s in rule_text)            

# dump all the messages
for m in messages:
    if test(m,[0])==0:
        print(m)

# Run for part 1
print("Part 1:", sum(test(m,[0]) for m in messages))       

# For part 2 add the additional "loop" rules
rule_text += ["8: 42 | 42 8","11: 42 31 | 42 11 31"]

# Run for part 2
rules = dict(parse(s) for s in rule_text)

# count how many match part 2, starting with message "m" and "rule in [0]"
print("Part 2:", sum(test(m,[0]) for m in messages))

# dump all the rules
#for r in rules:
    #print(r)

#print(rules[0])
