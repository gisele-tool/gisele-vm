# Writing a VM listener

This example demonstrates how to write a single VM listener (see inside.rb).

To run it (the first line ensures ruby dependencies are properly installed):

```
bundle install
bundle exec ruby inside.rb treatment.gis
```

This will launch a VM instance with a console. A typical session in that console is as follows:

* Start a new Treatment: `start Treatment`
* Observe the events seen by the Listener instance
* Let the VM know that the Consultation task as been ended: `resume 2 :ended`
* Observe the events seen by the Listener instance
* ...

## Example

```
athena:listening blambeau$ bundle exec ruby inside.rb treatment.gis
I, [2013-03-08T15:42:37.059159 #3854]  INFO -- : VM start request received, connecting.
I, [2013-03-08T15:42:37.059270 #3854]  INFO -- : Component <Registry> connecting.
I, [2013-03-08T15:42:37.059308 #3854]  INFO -- : Component <Kernel> connecting.
I, [2013-03-08T15:42:37.059338 #3854]  INFO -- : Component <ProgList> connecting.
I, [2013-03-08T15:42:37.059379 #3854]  INFO -- : Component <Sqldb> connecting.
I, [2013-03-08T15:42:37.090715 #3854]  INFO -- : Component <EventManager> connecting.
I, [2013-03-08T15:42:37.090805 #3854]  INFO -- : Component <Enacter> connecting.
I, [2013-03-08T15:42:37.090891 #3854]  INFO -- : Component <Console> connecting.
I, [2013-03-08T15:42:37.090928 #3854]  INFO -- : Gisele VM has taken stage!
I, [2013-03-08T15:42:37.091034 #3854]  INFO -- : Component <Enacter> entering heartbeat.
I, [2013-03-08T15:42:37.091100 #3854]  INFO -- : Component <Console> entering heartbeat.

? Please choose an action:(list, new, resume or quit)
gisele-vm> new Treatment

? Please choose an action:(list, new, resume or quit)
gisele-vm>

SEEN: Treatment:start (1 with parent 1)
SEEN: Consultation:start (2 with parent 1)


? Please choose an action:(list, new, resume or quit)
gisele-vm> list
+-------+---------------------------------------------------------------+
| :root | :progs                                                        |
+-------+---------------------------------------------------------------+
|     1 | +-------+---------+--------+-----------+-----------+--------+ |
|       | | :puid | :parent | :pc    | :waitfor  | :waitlist | :input | |
|       | +-------+---------+--------+-----------+-----------+--------+ |
|       | |     1 |       1 | :s8    | :children | [2]       | []     | |
|       | |     2 |       1 | :react | :world    | [:ended]  | []     | |
|       | +-------+---------+--------+-----------+-----------+--------+ |
+-------+---------------------------------------------------------------+

? Please choose an action:(list, new, resume or quit)
gisele-vm> resume 2 :ended

? Please choose an action:(list, new, resume or quit)
gisele-vm>

SEEN: Consultation:end (2 with parent 1)
SEEN: Endoscopy:start (5 with parent 1)
SEEN: Chemotherapy:start (6 with parent 1)


? Please choose an action:(list, new, resume or quit)
gisele-vm> list
+-------+---------------------------------------------------------------+
| :root | :progs                                                        |
+-------+---------------------------------------------------------------+
|     1 | +-------+---------+--------+-----------+-----------+--------+ |
|       | | :puid | :parent | :pc    | :waitfor  | :waitlist | :input | |
|       | +-------+---------+--------+-----------+-----------+--------+ |
|       | |     1 |       1 | :s14   | :children | [3, 4]    | []     | |
|       | |     2 |       1 |     -1 | :none     | []        | []     | |
|       | |     3 |       1 | :s18   | :children | [5]       | []     | |
|       | |     4 |       1 | :s31   | :children | [6]       | []     | |
|       | |     5 |       3 | :react | :world    | [:ended]  | []     | |
|       | |     6 |       4 | :react | :world    | [:ended]  | []     | |
|       | +-------+---------+--------+-----------+-----------+--------+ |
+-------+---------------------------------------------------------------+

? Please choose an action:(list, new, resume or quit)
gisele-vm> quit
I, [2013-03-08T15:43:02.209983 #3854]  INFO -- : VM stop request received, disconnecting.
I, [2013-03-08T15:43:02.210183 #3854]  INFO -- : Component <Registry> disconnected.
I, [2013-03-08T15:43:02.210273 #3854]  INFO -- : Component <Kernel> disconnected.
I, [2013-03-08T15:43:02.210350 #3854]  INFO -- : Component <ProgList> disconnected.
I, [2013-03-08T15:43:02.210429 #3854]  INFO -- : Component <Sqldb> disconnected.
I, [2013-03-08T15:43:02.210684 #3854]  INFO -- : Component <EventManager> disconnected.
I, [2013-03-08T15:43:02.210806 #3854]  INFO -- : Component <Enacter> exiting heartbeat.
I, [2013-03-08T15:43:02.210880 #3854]  INFO -- : Component <Enacter> disconnected.
I, [2013-03-08T15:43:02.210951 #3854]  INFO -- : Component <Console> disconnected.
I, [2013-03-08T15:43:02.211073 #3854]  INFO -- : VM stopped successfully.
```
