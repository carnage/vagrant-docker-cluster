import sys, json
from select import select

rlist, _, _ = select([sys.stdin], [], [], 0.1)
if rlist:
    jsonStr = sys.stdin.read()
else:
  print 'Usage: docker --host <swarm_host>:<swarm_port> inspect <container> | python link.py <alias>'
  sys.exit()

try:
  containerConf = json.loads(jsonStr)[0]
except:
  print 'Usage: docker --host <swarm_host>:<swarm_port> inspect <container> | python link.py <alias>'
  sys.exit()

try:
  alias = sys.argv[1].upper()
except:
  alias = 'LINK'

env = containerConf['Config']['Env']

for x in env:
  #print  x[0:4]
  if x[0:4] == 'PATH' or x[0:4] == 'HOME':
	continue
  print '-e %s_ENV_%s' % (alias, x),
  
ns = containerConf['NetworkSettings']['Ports']

for z in ns:
  port, prot = z.split('/')
  ns[z][0]['HostIp']
  ns[z][0]['HostPort']
  addr = '%s://%s:%s' % (prot, ns[z][0]['HostIp'], ns[z][0]['HostPort'])
  print '-e %s_PORT_%s_%s_PROTO=%s' % (alias, port, prot.upper(), prot),
  print '-e %s_PORT_%s_%s_PORT=%s' % (alias, port, prot.upper(), ns[z][0]['HostPort']),
  print '-e %s_PORT_%s_%s_ADDR=%s' % (alias, port, prot.upper(), ns[z][0]['HostIp']),
  print '-e %s_PORT_%s_%s=%s' % (alias, port, prot.upper(), addr),
