#pragma D option quiet
objc$target:::entry
{
   printf("%s %s\n", probemod, probefunc);
}
